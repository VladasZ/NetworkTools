//
//  Parameters.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 1/9/18.
//  Copyright © 2018 Vladas Zakrevskis. All rights reserved.
//

import Foundation
import SwiftyTools

public protocol Parameters {
    var dictionary: [String : Any]? { get }
}

public extension Parameters {
    
    func appendToUrl(_ url: URLConvertible) -> URL? {
        guard let dict = self.dictionary else { Log.error(); return url.url }
        guard let _url = url.url else { Log.error(); return url.url }
        guard var components = URLComponents(string: _url.string) else { Log.error(); return url.url }
        
        var items = [URLQueryItem]()
        
        for (key, value) in dict {
            items.append(URLQueryItem(name: key, value: String(describing: value)))
        }
        
        components.queryItems = items
        
        return components.url
    }
}

extension Dictionary : Parameters {
    public var dictionary: [String : Any]? {
        return self as? [String : Any]
    }
}
