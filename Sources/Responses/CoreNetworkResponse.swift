//
//  CoreNetworkResponse.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 10/13/17.
//  Copyright © 2017 Vladas Zakrevskis All rights reserved.
//

import SwiftyTools

class CoreNetworkResponse {
    
    public var requestURL:   URLConvertible
    public var method:       HTTPMethod
    public var responseCode: Int?
    public var error:        NetworkError?
    
    public var block: Block
    
    init(requestURL:   URLConvertible,
         method:       HTTPMethod,
         responseCode: Int? = nil,
         _ error:      NetworkError? = nil,
         _ block:      Block? = nil) {
        
        self.requestURL   = requestURL
        self.method       = method
        self.responseCode = responseCode
        
        self.block = block ?? Block.empty
        
        if let error = block?["error"]?.string {
            self.error = .networkError(error)
            return
        }
        
        self.error = error
    }
}
