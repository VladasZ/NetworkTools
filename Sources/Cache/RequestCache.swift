//
//  RequestCache.swift
//  Actors Pocket Guide
//
//  Created by Vladas Zakrevskis on 10/1/20.
//  Copyright © 2020 Atomichronica. All rights reserved.
//

import Foundation


class RequestCache {
    
    let request: Request
    let response: CoreNetworkResponse
    
    init(request: Request, response: CoreNetworkResponse) {
        self.request  = request
        self.response = response
    }
    
}
