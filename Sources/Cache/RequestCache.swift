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
    
    var age: Double { request.age }
    
    var tooOld: Bool { age > 15 }
    
    var request: Request
    var response: CoreNetworkResponse
    
    private init(request: Request, response: CoreNetworkResponse) {
        self.request  = request
        self.response = response
    }
    
    required init() {
        request  = Request()
        response = CoreNetworkResponse()
    }
    
    static func store(request: Request, response: CoreNetworkResponse) {
        objc_sync_enter(self)
        cache.append(RequestCache(request: request, response: response))
        objc_sync_exit(self)
    }
    
    static func getFor(_ request: Request) -> CoreNetworkResponse? {
                        
        guard let cache = (self.cache.first { $0.request.tempHash == request.tempHash }) else {
            Log("No cache")
            return nil
        }
                
        if cache.tooOld {
            if !Connection.ok {
                return cache.response
            }
            objc_sync_enter(self)
            self.cache.remove(cache)
            objc_sync_exit(self)
            return nil
        }
        
        return cache.response
        
//        for note in cache {
//            if note.request.tempHash == request.tempHash {
//                Log("cached")
//                if note.tooOld && Connection.ok {
//                    oldCache = note
//                    break;
//                }
//                objc_sync_exit(self)
//                return note.response
//            }
//        }
        
//        if let old = oldCache {
//            cache.remove(old)
//        }
            
     //   objc_sync_exit(self)
     //   return nil
        
    }
    
}

extension RequestCache {
    
    @CompressedStringStorage("APGCacheStorage")
    private static var cacheStorage: String
    
    static func invalidate() {
        cache = []
        cacheStorage = ""
    }
    
    static func store() {
        cacheStorage = cache.toJsonString()
    }
    
    static func restore() {
        if !Network.cacheRequests { return }
        
        let json = cacheStorage
        if json.isEmpty {
            Log("No cache")
            return
        }
        cache = [RequestCache](json: json)
        Log("\(cache.count) cached requests loaded.")
    }
    
}
