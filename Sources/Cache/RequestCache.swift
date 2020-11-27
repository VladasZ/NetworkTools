//
//  RequestCache.swift
//  Actors Pocket Guide
//
//  Created by Vladas Zakrevskis on 10/1/20.
//  Copyright © 2020 Atomichronica. All rights reserved.
//

import Foundation


fileprivate class Key {
    static let request  = "request"
    static let response = "response"
    static let maxAge   = "maxAge"
}

class RequestCache : BlockConvertible {
    
    var request: RequestInfo
    var response: CoreNetworkResponse
    var maxAge: Double
    
    private init(request: RequestInfo, response: CoreNetworkResponse, maxAge: Double) {
        self.request  = request
        self.response = response
        self.maxAge   = maxAge
    }
    
    required init() {
        request  = RequestInfo()
        response = CoreNetworkResponse()
        maxAge   = 15
    }

    required init(block: Block) throws {
        request  = try block.extract(Key.request)
        response = try block.extract(Key.response)
        maxAge   = try block.extract(Key.maxAge)
    }

    func createBlock(block: inout Block) {
        block.append(Key.request,  request)
        block.append(Key.response, response)
        block.append(Key.maxAge,   maxAge)
    }
}

extension RequestCache {
    
    @CompressedStringStorage("APGCacheStorage")
    private static var cacheStorage: String

    static func store() {
        LogWarning(cache.block.JSONString)
        cacheStorage = cache.block.JSONString
    }
    
    static func restore() {

        if Network.cacheDisabled {
            Log("Request cache disabled")
            return
        }
        
        let json = cacheStorage
        if json.isEmpty || json == "{}" {
            Log("No cache")
            return
        }
        
        guard let parsedCache = try? [RequestCache](block: Block(string: json)) else {
            LogError("Failed to parse request cache")
            return
        }
        
        RequestCache.cache = parsedCache
        Log("\(cache.count) cached requests loaded.")
    }
    
}

extension RequestCache {

    static func store(request: RequestInfo, response: CoreNetworkResponse, maxAge: Double) {
        objc_sync_enter(self)
        cache.append(RequestCache(request: request, response: response, maxAge: maxAge))
        store()
        objc_sync_exit(self)
    }

    static func getFor(_ request: RequestInfo) -> CoreNetworkResponse? {
        guard let stored = (cache.first { $0.request.tempHash == request.tempHash }) else {
            Log("No cache")
            return nil
        }
        return stored.response
    }

}

extension RequestCache {

    private static var cache: [RequestCache] = []

    var age: Double { request.age }
    var tooOld: Bool { age > maxAge }
}
