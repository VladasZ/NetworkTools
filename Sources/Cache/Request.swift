//
//  Request.swift
//  Actors Pocket Guide
//
//  Created by Vladas Zakrevskis on 10/1/20.
//  Copyright © 2020 Atomichronica. All rights reserved.
//

import Foundation


class Request : Mappable {
    
    let url:       String
    let method:    String
    let params:    String
    let headers:   Headers
    let urlEncode: Bool
    
    private let time: TimeInterval
        
    init(url:       String,
         method:    String,
         params:    String?,
         headers:   Headers,
         urlEncode: Bool) {
        self.url       = url
        self.method    = method
        self.params    = params.anyString
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

    var tempHash: String {
        url + method + params + " \(headers.hashValue)"
    }
    
}
