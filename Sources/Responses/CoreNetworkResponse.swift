//
//  CoreNetworkResponse.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 10/13/17.
//  Copyright © 2017 Vladas Zakrevskis All rights reserved.
//

import SwiftyTools

class CoreNetworkResponse {
    
    var error: NetworkError?
    var block: Block?
    
    init(_ error: NetworkError? = nil, _ block: Block? = nil) {
        
        self.block = block
        
        if let error = block?["error"]?.string {
            self.error = .networkError(error)
            return
        }
        
        self.error = error
    }
}
