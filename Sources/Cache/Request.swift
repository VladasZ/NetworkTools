//
//  Request.swift
//  Actors Pocket Guide
//
//  Created by Vladas Zakrevskis on 10/1/20.
//  Copyright © 2020 Atomichronica. All rights reserved.
//

import Foundation


class Request : Mappable {
    
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

    override var tempHash: Int {
        var hasher = Hasher()
        hasher.combine(url)
        hasher.combine(method)
        hasher.combine(params.tempHash)
        hasher.combine(headers)
        return hasher.finalize()
    }
    
}

extension Request {
    
    var age: Double { Date().timeIntervalSince1970 - time }
    
}
