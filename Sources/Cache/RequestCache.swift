//
//  RequestCache.swift
//  Actors Pocket Guide
//
//  Created by Vladas Zakrevskis on 10/1/20.
//  Copyright © 2020 Atomichronica. All rights reserved.
//

import Foundation


class RequestCache : Mappable {

    private static var cache: [RequestCache] = []
    
    let request: Request
    let response: CoreNetworkResponse
    
    private init(request: Request, response: CoreNetworkResponse) {
        self.request  = request
        self.response = response
    }
    
    required init() {
        request  = Request()
        response = CoreNetworkResponse()
    }
    
    static func store(request: Request, response: CoreNetworkResponse) {
        cache.append(RequestCache(request: request, response: response))
    }
    
    static func getFor(_ request: Request) -> CoreNetworkResponse? {
        
        for note in cache {
            if note.request.tempHash == request.tempHash {
               // LogWarning("From cache \(request.tempHash)")
                return note.response
            }
        }
        
        LogWarning("Getting \(request.tempHash)")
        
        return nil
        
    }
    
}
