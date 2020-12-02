//
//  Parameters.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 1/9/18.
//  Copyright © 2018 Vladas Zakrevskis. All rights reserved.
//

import Foundation


public protocol Parameters {
    var isInt:         Bool                   { get }
    var isArray:       Bool                   { get }
    var toString:      String                 { get }
    var toDictionary: [String : AnyHashable]? { get }
    var toJsonString:  String                 { get }
    var tempHash:      Int                    { get }
}

public extension Parameters {
    var isInt:         Bool                   { false     }
    var isArray:       Bool                   { false     }
    var toDictionary: [String : AnyHashable]? { nil       }
    var toJsonString:  String                 { "\(self)" }
}

public extension Parameters {
    
    func appendToUrl(_ url: URLConvertible) -> URL? {
        
        guard let dict       = self.toDictionary                         else { LogError(); return url.toUrl }
        guard let targetUrl  = url.toUrl                                 else { LogError(); return url.toUrl }
        guard var components = URLComponents(string: targetUrl.toString) else { LogError(); return url.toUrl }
        
        var items = [URLQueryItem]()
        
        for (key, value) in dict {
            items.append(URLQueryItem(name: key, value: Swift.String(describing: value)))
        }
        
        components.queryItems = items
        
        return components.url
    }
}

extension Dictionary : Parameters where Value: Hashable, Key: Comparable {
    public var toString:      String                 { toJSON(self) }
    public var toDictionary: [String : AnyHashable]? { self as? [String : AnyHashable] }
    public var tempHash: Int { hashValue }
}

extension String : Parameters {
    public var toString: String { self }
    public var tempHash: Int { hashValue }
}

extension Int : Parameters {
    public var toString: String { "\(self)" }
    public var isInt:    Bool   {    true   }
    public var tempHash: Int { hashValue }
}

extension Array : Parameters where Element: Numeric & Hashable {
    public var isArray: Bool { true }
    public var toString: String { "\(self)" }
    public var tempHash: Int { hashValue }
    public var toJsonString: String {
        if isEmpty { return "[]" }
        var result = "["
        for val in self {
            result += "\(val), "
        }
        return result.dropLast(2) + "]"
    }
}
