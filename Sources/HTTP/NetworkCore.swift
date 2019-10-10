//
//  NetworkCore.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 11/15/17.
//  Copyright © 2017 VladasZ. All rights reserved.
//

import SwiftyTools

public enum HTTPMethod : String {
    case get    = "GET"
    case post   = "POST"
    case delete = "DELETE"
    case put    = "PUT"
}

public class Network {
    
    public static var logBodyString = false
    public static var logResponses = false
    public static var logKeyExtractFailure = false
    public static var verboseExtractLog = false
    
    public static var customErrorHandle: ((Block?) -> String?)?
    
    internal static let session = URLSession(configuration: .default)
    
    internal static func coreRequest(_ url: URLConvertible,
                                     method: HTTPMethod,
                                     params: Parameters? = nil,
                                     headers: Headers,
                                     urlEncodeParams: Bool = false,
                                     _ completion: @escaping CoreRequestCompletion) {
        
        let inURL = url
        
        guard var _url = (baseURL + url)?.url
            else { completion(CoreNetworkResponse(requestURL: inURL, method:method, error: .invalidURL)); return }
        
        var body: Data?
        
        if let params = params {
            if params.isInt {
                guard let int_url = (_url.string + "/" + params.String)?.url
                        else { completion(CoreNetworkResponse(requestURL: inURL, method:method, error: .invalidURL)); return }
                _url = int_url
            }
            else if urlEncodeParams {
                guard let urlWithParams = params.appendToUrl(_url)
                    else { completion(CoreNetworkResponse(requestURL: _url, method:method, error: .noParams)); return }
                _url = urlWithParams
            }
            else {
                
                guard let utf8String = params.String?.utf8
                    else { completion(CoreNetworkResponse(requestURL: _url, method:method, error: .noParams)); return }
                
                body = Data(utf8String)
            }
        }
        
        if let body = body, logBodyString {
            let bodyString = String(decoding: body, as: UTF8.self)
            Log("Sending body: ")
            Log(bodyString)
        }
        
        var request = URLRequest(url: _url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                
                if logResponses {
                    Log("\(statusCode ?? -1) \(method.rawValue) \(_url)")
                }
                
                if let error = error?.localizedDescription, error != "null" {
                    completion(CoreNetworkResponse(requestURL: _url,
                                                   method: method,
                                                   responseCode: statusCode,
                                                   error: .networkError(error)))
                    return
                }
                
                guard let data = data else {
                    completion(CoreNetworkResponse(requestURL: _url,
                                                   method: method,
                                                   responseCode: statusCode,
                                                   error: .noData))
                    return
                }
                
                completion(CoreNetworkResponse(requestURL: _url,
                                               method: method,
                                               responseCode: statusCode,
                                               error: nil,
                                               block: Block(data:data)))
            }
            
            }.resume()
    }
}




