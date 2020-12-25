//
//  CoreNetworkResponse.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 10/13/17.
//  Copyright © 2017 Vladas Zakrevskis All rights reserved.
//

import Foundation


fileprivate class Key {
    static let requestURL   = "requestURL"
    static let method       = "method"
    static let responseCode = "responseCode"
    static let error        = "error"
    static let data         = "data"
}

class CoreNetworkResponse : BlockConvertible {

    public var requestURL:   String
    public var method:       HTTPMethod
    public var responseCode: Int
    public var error:        String?
    
    public var data: String
    
    init(requestURL:   String,
         method:       HTTPMethod,
         responseCode: Int? = nil,
         error:        String? = nil,
         data:         String = "") {
        
        self.requestURL   = requestURL
        self.method       = method
        self.responseCode = responseCode ?? -1
        
        self.data = data
        
        let block = Block(string: data)
        
        if let customHandle = Network.customErrorHandle {
            self.error = customHandle(error, block)
            return
        }
        
        if let error = block?["error"]?.toString, error != "null" {
            self.error = error
            return
        }
        
        self.error = error
        
        if let responseCode = responseCode {
            if self.error == nil && responseCode > 299 {
                self.error = "\(responseCode)"
            }
        }
        
    }
    
    required init() {
        requestURL   = ""
        method       = .get
        responseCode = -1
        data         = ""
    }

    required init(block: Block) throws {
        requestURL   = try block.extract(Key.requestURL)

        let methodString: String = try block.extract(Key.method)
        method       = HTTPMethod(rawValue: methodString.uppercased())!

        responseCode = try block.extract(Key.responseCode)

        data = try block.extract(Key.data)
        data = data.fromBase64()

        error = try? block.extract(Key.error)
    }

    func createBlock(block: inout Block) {
        block.append(Key.requestURL,   requestURL)
        block.append(Key.method,       method.rawValue)
        block.append(Key.responseCode, responseCode)
        block.append(Key.error,        error)

        block.append(Key.data, data.toBase64())
    }
    
}
