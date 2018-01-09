//
//  NetworkCore.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 11/15/17.
//  Copyright © 2017 VladasZ. All rights reserved.
//

import SwiftyTools

public enum HTTPMethod : String {
    case get = "GET"
    case post = "POST"
}

public class Network {
    
    internal static let session = URLSession(configuration: .default)
    
    internal static func coreRequest(_ url: URLConvertible,
                        method: HTTPMethod,
                        headers: Headers,
                        _ completion: @escaping CoreRequestCompletion) {
        
        
        let inURL = url
        
        guard let url = (baseURL + url)?.url else {
            completion(CoreNetworkResponse(requestURL: inURL, method:method, .invalidURL))
            return
            
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        session.dataTask(with: request) { data, response, error in
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            
            Log.info(statusCode)
            
            if let error = error?.localizedDescription {
                completion(CoreNetworkResponse(requestURL: url,
                                               method: method,
                                               responseCode: statusCode,
                                               .networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(CoreNetworkResponse(requestURL: url,
                                               method: method,
                                               responseCode: statusCode,
                                               .noData))
                return
            }
            
            completion(CoreNetworkResponse(requestURL: url,
                                           method: method,
                                           responseCode: statusCode,
                                           nil,
                                           Block(data:data)))
            }.resume()
    }
}
