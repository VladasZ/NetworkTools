//
//  RequestInfo.swift
//  Actors Pocket Guide
//
//  Created by Vladas Zakrevskis on 10/1/20.
//  Copyright © 2020 Atomichronica. All rights reserved.
//

import Foundation


fileprivate class Key {
    static let url       = "url"
    static let method    = "method"
    static let params    = "params"
    static let headers   = "headers"
    static let urlEncode = "urlEncode"
    static let time      = "time"
}

class RequestInfo: BlockConvertible {
    
    var url:       String
    var method:    String
    var params:    String
    var headers:   Headers
    var urlEncode: Bool
    
    private let time: TimeInterval
        
    init(url:       String,
         method:    String,
         params:    String?,
         headers:   Headers,
         urlEncode: Bool) {
        self.url       = url
        self.method    = method
        self.params    = params.anyString.toBase64()
        self.headers   = headers
        self.urlEncode = urlEncode
        
        time = Date().timeIntervalSince1970
    }
    
    required init() {
        url     = ""
        method  = ""
        params  = ""
        headers = [:]
        time    = 0
        urlEncode = false
    }
    
    var info: String {
        "\(url) \(method) \(params) \(headers)"
    }

    var tempHash: Int {
        var hasher = Hasher()
        hasher.combine(url)
        hasher.combine(method)
        hasher.combine(params)
        hasher.combine(headers)
        return hasher.finalize()
    }

    required init(block: Block) throws {
        url       = try block.extract(Key.url)
        method    = try block.extract(Key.method)
        params    = block.tryExtract(Key.params)
        headers   = try block.extract(Key.headers)
        time      = try block.extract(Key.time)
        urlEncode = try block.extract(Key.urlEncode)
    }

    func createBlock(block: inout Block) {
        block.append(Key.url,       url)
        block.append(Key.method,    method)
        block.append(Key.params,    params)
        block.append(Key.headers,   headers)
        block.append(Key.time,      time)
        block.append(Key.urlEncode, urlEncode)
    }
}

fileprivate func convertToDictionary(_ text: String) throws -> [String: String] {
    guard let data = text.data(using: .utf8) else { return [:] }
    let anyResult: Any = try JSONSerialization.jsonObject(with: data, options: [])
    return anyResult as? [String: String] ?? [:]
}

extension RequestInfo {
    
    var age: Double { Date().timeIntervalSince1970 - time }
    
}
