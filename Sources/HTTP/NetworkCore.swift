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
    
    internal static let session = URLSession(configuration: .default)
    
    internal static func coreRequest(_ url: URLConvertible,
                                     method: HTTPMethod,
                                     params: Parameters? = nil,
                                     headers: Headers,
                                     _ completion: @escaping CoreRequestCompletion) {
        
        let inURL = url
        
        guard var _url = (baseURL + url)?.url
        else { completion(CoreNetworkResponse(requestURL: inURL, method:method, .invalidURL)); return }
        
        if let params = params {

            if method == .get {
                guard let urlWithParams = params.appendToUrl(_url)
                else { completion(CoreNetworkResponse(requestURL: _url, method:method, .noParams)); return }
                
                _url = urlWithParams
            }
            else {
                completion(CoreNetworkResponse(requestURL: _url, method:method, .notImplemented)); return
            }
        }
        
        var request = URLRequest(url: _url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                
                Log.info("\(statusCode ?? -1) \(_url)")
                
                if let error = error?.localizedDescription {
                    completion(CoreNetworkResponse(requestURL: _url,
                                                   method: method,
                                                   responseCode: statusCode,
                                                   .networkError(error)))
                    return
                }
                
                guard let data = data else {
                    completion(CoreNetworkResponse(requestURL: _url,
                                                   method: method,
                                                   responseCode: statusCode,
                                                   .noData))
                    return
                }
                
                completion(CoreNetworkResponse(requestURL: _url,
                                               method: method,
                                               responseCode: statusCode,
                                               nil,
                                               Block(data:data)))
            }
            
            }.resume()
    }
}
