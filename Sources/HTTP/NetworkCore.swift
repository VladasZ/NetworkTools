//
//  NetworkCore.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 11/15/17.
//  Copyright © 2017 VladasZ. All rights reserved.
//

import Foundation


public enum HTTPMethod : String {
    case get    = "GET"
    case post   = "POST"
    case delete = "DELETE"
    case put    = "PUT"
    case patch  = "PATCH"
}

public class Network {

    public static var logCalls             = false
    public static var logResponses         = false
    public static var cacheEnabled         = false
    public static var logBodyString        = false
    public static var verboseExtractLog    = false
    public static var logKeyExtractFailure = false
    
    public static var forceCacheTarget: String?
    
    public static var forceCache: Bool {
        forceCacheTarget != nil
    }
    
    public static var defaultCacheParams: CacheParams {
        CacheParams(enabled: cacheEnabled, maxAge: 0)
    }

    public static var cacheDisabled: Bool { get { !cacheEnabled } set { cacheEnabled = !newValue } }

    public static var customErrorHandle: ((Int, String?, Block?) -> String?)?

    internal static let session = URLSession(configuration: .default)
    
    internal static func downloadRequest(_ url: URLConvertible,
                                         headers: Headers,
                                         _ completion: @escaping DownloadCompletion) {
        async {
            guard let targetUrl = (baseURL + url).toUrl else {
                sync { completion(nil, nil, "Incorrect url") }
                return
            }
            var request = URLRequest(url: targetUrl)
            request.allHTTPHeaderFields = headers
            
            session.downloadTask(with: request) { url, response, error in
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1

                if logResponses {
                    Log("\(statusCode) \(targetUrl)")
                }

                if let error = error?.localizedDescription, error != "null" {
                    sync {
                        completion(nil, nil, error)
                    }
                    return
                }

                guard let data = response else {
                    sync {
                        completion(nil, nil, "No Data in response")
                    }
                    return
                }
                sync { completion(url, data, nil) }

            }.resume()
        }
    }

    internal static func coreRequest(_ url: URLConvertible,
                                     method: HTTPMethod,
                                     params: Parameters? = nil,
                                     headers: Headers,
                                     cacheParams: CacheParams = defaultCacheParams,
                                     urlEncodeParams: Bool = false,
                                     _ completion: @escaping CoreRequestCompletion) {

        async {

            let requestForCache = RequestInfo(url: url.toString,
                    method: method.rawValue,
                    params: params?.toString,
                    headers: headers,
                    urlEncode: urlEncodeParams)

            if cacheParams.shoudeGetFromCache {
                if let cachedResponse = RequestCache.getFor(requestForCache) {
                    sync { completion(cachedResponse) }
                    return
                }
            }

            let inURL = url

            guard var targetUrl = (baseURL + url).toUrl else {
                sync { completion(CoreNetworkResponse(requestURL: inURL.toString, method: method, error: "invalid URL")) }
                return
            }

            var body: Data?

            if let params = params {
                if params.isInt {
                    guard let urlAppendingInt = (targetUrl.toString + "/" + params.toString).toUrl else {
                        sync { completion(CoreNetworkResponse(requestURL: inURL.toString, method: method, error: "invalid URL")) }
                        return
                    }
                    targetUrl = urlAppendingInt
                }
                else if params.isArray {
                    body = Data(params.toJsonString.utf8)
                }
                else if urlEncodeParams {
                    guard let urlWithParams = params.appendToUrl(targetUrl) else {
                        sync { completion(CoreNetworkResponse(requestURL: targetUrl.toString, method: method, error: "no params")) }
                        return
                    }
                    targetUrl = urlWithParams
                }
                else {
                    body = Data(params.toString.utf8)
                }
            }

            if let body = body, logBodyString {
                let bodyString = String(decoding: body, as: UTF8.self)
                Log("Sending body: ")
                Log(bodyString)
            }

            var request = URLRequest(url: targetUrl)
            request.httpMethod = method.rawValue
            request.allHTTPHeaderFields = headers
            request.httpBody = body

            if logCalls {
                Log("\(method.rawValue) \(targetUrl.toString)")
            }

            session.dataTask(with: request) { data, response, error in
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1

                if logResponses {
                    Log("\(statusCode) \(method.rawValue) \(targetUrl)")
                }

                if let error = error?.localizedDescription, error != "null" {
                    sync {
                        completion(CoreNetworkResponse(requestURL: targetUrl.toString,
                                method: method,
                                responseCode: statusCode,
                                error: error))
                    }
                    return
                }

                guard let data = data else {
                    sync {
                        completion(CoreNetworkResponse(requestURL: targetUrl.toString,
                                method: method,
                                responseCode: statusCode,
                                error: "no data"))
                    }
                    return
                }

                let response = CoreNetworkResponse(requestURL: targetUrl.toString,
                        method: method,
                        responseCode: statusCode,
                        error: nil,
                        data: String(data: data, encoding: .utf8) ?? "")

                if cacheParams.shouldCache {
                    RequestCache.store(request: requestForCache, response: response, maxAge: cacheParams.maxAge, target: forceCacheTarget)
                }
                else {
                    LogWarning("Shouldnt store cache \(requestForCache.url)", enabled: RequestCache.logEnabled)
                }

                sync { completion(response) }

            }.resume()

        }
    }
}
