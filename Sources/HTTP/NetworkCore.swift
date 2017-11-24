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
    
    internal static func coreRequest(_ url: URLConvertible?,
                        method: HTTPMethod,
                        headers: Headers,
                        _ completion: @escaping CoreRequestCompletion) {
        
        guard let url = (baseURL + url)?.url else {
            completion(CoreNetworkResponse(.invalidURL))
            return
            
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        session.dataTask(with: request) { data, response, error in
            
            if let error = error?.localizedDescription {
                completion(CoreNetworkResponse(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(CoreNetworkResponse(.noData))
                return
            }
            
            completion(CoreNetworkResponse(nil, Block(data:data)))
        }.resume()
    }
}
