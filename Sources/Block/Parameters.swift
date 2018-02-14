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
    var String:      String?        { get }
    var Dictionary: [String : Any]? { get }
}

public extension Parameters {
    var String:      String?        { return nil }
    var Dictionary: [String : Any]? { return nil }
}

public extension Parameters {
    
    func appendToUrl(_ url: URLConvertible) -> URL? {
        
        if let string = self.String {
            return (url.string + string).url
        }
        
        guard let dict = self.Dictionary else { Log.error(); return url.url }
        guard let _url = url.url else { Log.error(); return url.url }
        guard var components = URLComponents(string: _url.string) else { Log.error(); return url.url }
        
        var items = [URLQueryItem]()
        
        for (key, value) in dict {
            items.append(URLQueryItem(name: key, value: Swift.String(describing: value)))
        }
        
        components.queryItems = items
        
        return components.url
    }
}

extension Dictionary : Parameters {
    public var Dictionary: [String : Any]? {
        return self as? [String : Any]
    }
}

extension String : Parameters {
    public var String: String? { return self }
}

extension Int : Parameters {
    public var String: String? { return "\(self)" }
}
