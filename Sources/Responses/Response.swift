//
//  Response.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 1/9/18.
//  Copyright © 2018 Vladas Zakrevskis. All rights reserved.
//

import Foundation

public class Response {
    
    public var requestURL:   URLConvertible = ""
    public var method:       HTTPMethod
    public var responseCode: Int?
    public var error:        NetworkError?
    public var block:        Block
    
    internal init(response: CoreNetworkResponse) {
        requestURL   = response.requestURL
        method       = response.method
        responseCode = response.responseCode
        error        = response.error
        block        = response.block
    }
}
