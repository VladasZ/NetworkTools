//
//  CoreNetworkResponse.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 10/13/17.
//  Copyright © 2017 Vladas Zakrevskis All rights reserved.
//

import Foundation


class CoreNetworkResponse : Mappable {
    
    public var requestURL:   String
    public var method:       HTTPMethod
    public var responseCode: Int
    public var error:        NetworkError?
    
    public var data: String
    
    init(requestURL:   String,
         method:       HTTPMethod,
         responseCode: Int? = nil,
         error:        NetworkError? = nil,
         data:         String = "") {
        
        self.requestURL   = requestURL
        self.method       = method
        self.responseCode = responseCode ?? -1
        
        self.data = data
        
        let block = Block(string: data)
        
        if let customHandle = Network.customErrorHandle {
            if let error = customHandle(block) {
                self.error = .networkError(error)
                return
            }
        }
        
        if let error = block?["error"]?.toString, error != "null" {
            self.error = .networkError(error)
            return
        }
        
        self.error = error
        
        if let responseCode = responseCode {
            if self.error == nil && responseCode > 299 {
                self.error = .networkError("\(responseCode)")
            }
        }
        
    }
    
    required init() {
        requestURL   = ""
        method       = .get
        responseCode = -1
        data         = ""
    }
    
    override public func propertyMapping() -> [(keyInObject: String?, keyInResource: String?)] {
        [(keyInObject: "error", keyInResource: nil)]
    }
    
}
