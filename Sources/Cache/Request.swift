//
//  Request.swift
//  Actors Pocket Guide
//
//  Created by Vladas Zakrevskis on 10/1/20.
//  Copyright © 2020 Atomichronica. All rights reserved.
//

import Foundation


class Request {
        
    let url:       String
    let method:    String
    let params:    String
    let headers:   Headers
    let urlEncode: Bool
    
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
    }
    
}

extension Request : CustomStringConvertible {
    
    var description: String {
        """

        url:      \(url    )
        method:   \(method )
        params:   \(params )
        headers:  \(headers)
        urlEncode \(urlEncode)
        """
    }
    
}

extension Request : Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        hasher.combine(method)
        hasher.combine(params)
        hasher.combine(headers)
        hasher.combine(urlEncode)
    }

    static func == (lhs: Request, rhs: Request) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

}
