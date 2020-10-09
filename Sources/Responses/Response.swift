//
//  Response.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 1/9/18.
//  Copyright © 2018 Vladas Zakrevskis. All rights reserved.
//

import Foundation


public class Response {
    
    public var requestURL:   URLConvertible
    public var method:       HTTPMethod
    public var responseCode: Int?
    public var networkError: NetworkError?
    public var block:        Block
    public var data:         String
    public var error:        String? { networkError?.localizedDescription }
    public var e:            String? { error } // ¯\_(ツ)_/¯

    internal init(response: CoreNetworkResponse) {
        requestURL   = response.requestURL
        method       = response.method
        responseCode = response.responseCode
        networkError = response.error
        block        = Block(string: response.data) ?? Block.empty
        data =       response.data
    }
    
}
