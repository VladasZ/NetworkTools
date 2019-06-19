//
//  NetworkCore.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 11/15/17.
//  Copyright © 2017 VladasZ. All rights reserved.
//

import SwiftyTools

public enum HTTPMethod : String {
    case get  = "GET"
    case post = "POST"
}

public class Network {
    
    public static var sendUrlEncodedParameters = false
    public static var logBodyString = false
    
    internal static let session = URLSession(configuration: .default)
    
    internal static func coreRequest(_ url: URLConvertible,
                                     method: HTTPMethod,
                                     params: Parameters? = nil,
                                     headers: Headers,
                                     _ completion: @escaping CoreRequestCompletion) {
        
        let inURL = url
        
        guard var _url = (baseURL + url)?.url
            else { completion(CoreNetworkResponse(requestURL: inURL, method:method, error: .invalidURL)); return }
        
        var body: Data?
        
        if let params = params {
            if sendUrlEncodedParameters {
                guard let urlWithParams = params.appendToUrl(_url)
                    else { completion(CoreNetworkResponse(requestURL: _url, method:method, error: .noParams)); return }
                _url = urlWithParams
            }
            else {
                
                guard let utf8String = params.String?.utf8
                    else { completion(CoreNetworkResponse(requestURL: _url, method:method, error: .noParams)); return }
                
                if logBodyString {
                    Log.info(utf8String)
                }
                
                body = Data(utf8String)
            }
        }
        
        var request = URLRequest(url: _url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                
                Log.info("\(statusCode ?? -1) \(_url)")
                
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




