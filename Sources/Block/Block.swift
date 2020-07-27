//
//  Block.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 6/14/17.
//  Copyright © 2017 VladasZ. All rights reserved.
//

import Foundation

public func toJSON(_ value: Any) -> String {
    guard let data = try? JSONSerialization.data(withJSONObject: value, options: []) else { return "No JSON data" }
    return data.JSONString.replacingOccurrences(of: "\\\"", with: "\"")
}

public class Block {
    
    //MARK: - Static properties
    
    public static var empty:     Block { container                      }
    public static var container: Block { Block(value: [String : Any]()) }
    
    //MARK: - Properties
    
    public var value: Any!
    
    public var toString:     String?         { value as? String }
    public var toInt:        Int?            { value as? Int    }
    public var toDouble:     Double?         { value as? Double }
    public var toBool:       Bool?           { value as? Bool   }
    public var toDictionary: [String : Any]? { value as? [String : Any] }
    
    public var JSONString: String {
        guard let value = value else { return "No value" }
        return toJSON(value)
    }
    
    public var toArray: [Block]? {
        guard let array = value as? [Any] else { return nil }
        return array.map { Block(value: $0) }
    }
    
    public subscript (_ key: String) -> Block? {
        guard let dict = value as? [String : Any] else { return nil }
        guard let value = dict[key] else { return nil }
        return Block(value: value)
    }
    
    //MARK: - Extraction
    
    private func riseFailure(_ message: String,
                             _ file:String = #file,
                             _ function:String = #function,
                             _ line:Int = #line) throws -> Never
    {
        if Network.logKeyExtractFailure {
            LogError(message, file, function, line)
        }
        throw message
    }
    
    public func extract<T>(_ key: String) throws -> T {
        
        guard let value: T = self[key]?.value as? T else {
            try riseFailure("Failed to extract block for key: \(key)")
        }
        
        return value
    }
    
    public func extract<T>(_ key: String) throws -> T where T : BlockConvertible {
        
        guard let block = self[key] else {
            try riseFailure("Failed to extract block for key: \(key)")
        }
        
        return try T(block: block)
    }
    
    public func extract<T, T2>(_ key: String, _ convert: (T2) -> T) throws -> T  {
        
        guard let value = self[key]?.value as? T2 else {
            try riseFailure("Failed to extract block for key: \(key)")
        }
        
        return convert(value)
    }
    
    public func extract<T>(_ key: String) throws -> [T] where T : BlockSupportedType {
        
        guard let array = self[key]?.toArray else {
            try riseFailure("Failed to extract block for key: \(key)")
        }
        
        guard let result = (array.map { $0.value }) as? [T] else {
            try riseFailure("Failed to extract block for key: \(key)")
        }
        
        return result
    }
    
    public func extract<T, T2>(_ key: String, _ convert: @escaping (T2) -> T) throws -> [T] where T : BlockSupportedType {
        
        guard let array = self[key]?.toArray else {
            try riseFailure("Failed to extract block for key: \(key)")
        }
        
        return try array.map { (block) -> T in
            guard let value = block.value as? T2 else {
                try riseFailure("Failed to extract block for key: \(key)")
            }
            return convert(value)
        }
    }
    
    public func extract<T>(_ key: String) throws -> [T] where T : BlockConvertible {
        
        guard let data = self[key], data.toArray != nil else {
            try riseFailure("Failed to extract block for key: \(key)")
        }
        
        return try [T](block: data)
    }
    
    public func tryExtract<T: DefaultInitializable>(_ key: String, _ def: T? = nil) -> T {
        do {
            return try extract(key)
        }
        catch {
            return def ?? T.defaultValue
        }
    }
    
    public func tryExtract<T>(_ key: String, _ def: [T]) -> [T] {
        do {
            return try extract(key)
        }
        catch {
            return def
        }
    }
    
    //MARK: - Serialization
    
    var toData: Data? {
        guard let dictionary = toDictionary else { LogError(); return nil }
        return try? JSONSerialization.data(withJSONObject: dictionary, options: [])
    }
    
    public func append(_ key: String, _ value: BlockConvertible?) {
        guard let value      = value                    else {                return }
        guard var dictionary = toDictionary             else { LogError(key); return }
        guard let data       = value.block.toDictionary else { LogError(key); return }
        
        dictionary[key] = data
        self.value = dictionary
    }
    
    public func append(_ key: String, _ value: [BlockConvertible]?) {
        
        guard let value      = value        else {                return }
        guard var dictionary = toDictionary else { LogError(key); return }
        
        dictionary[key] = value.map{ value -> [String : Any] in
            if let dictionary = value.toDictionary { return dictionary }
            else { LogError(); return ["error" : "error"] }
        }
        self.value = dictionary
        return
    }
    
    public func append(_ key: String, _ value: BlockSupportedType?, appendsNil: Bool = false) {
        
        guard var dictionary = toDictionary else { LogError(); return }
        
        if appendsNil {
            if let value = value { dictionary[key] = value    }
            else                 { dictionary[key] = NSNull() }
        }
        else {
            guard let value = value else { return }
            if let value    = value as? String { if value.isEmpty { return } }
            dictionary[key] = value
        }
        
        self.value = dictionary
    }
    
    public func append(_ key: String, _ value: [BlockSupportedType]?) {
        guard let value      = value        else {             return }
        guard var dictionary = toDictionary else { LogError(); return }
                
        dictionary[key] = value
        self.value = dictionary
    }
    
    public func appendStringToArray(_ string: String) {
        guard let stringData = Block(string: string) else { LogError(); return }
        guard var array      = self.toArray          else { LogError(); return }
        array.append(stringData)
        value = array.map { $0.value }
    }
    
    //MARK: - Initialization
    
    public init(value: Any) {
        self.value = value
    }
    
    public init?(string: String) {
        guard let data = string.data(using: .utf8) else { return }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else { return }
        value = json
    }
    
    public init?(data: Data?) {
        guard let data = data else { return nil }
                
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
            value = json
        }
        else if let string = String(data: data, encoding: String.Encoding.utf8) {
            value = string
        }
        else {
            return nil
        }
    }
    
    public init(dictionary: [String : Any] = [String : Any]()) {
        self.value = dictionary
    }
    
    public convenience init(error: String) {
        self.init(dictionary: ["error" : error])
    }
}
