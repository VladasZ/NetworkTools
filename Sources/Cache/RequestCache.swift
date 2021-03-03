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
    static let target   = "target"
}

class RequestCache : BlockConvertible {

    static var logEnabled = false

    var request: RequestInfo
    var response: CoreNetworkResponse
    var maxAge: Double
    var target: String?
    
    private init(request: RequestInfo, response: CoreNetworkResponse, maxAge: Double, target: String?) {
        self.request  = request
        self.response = response
        self.maxAge   = maxAge
        self.target   = target
    }
    
    required init() {
        request  = RequestInfo()
        response = CoreNetworkResponse()
        maxAge   = 15
    }

    required init(block: Block) throws {
        request  = try  block.extract(Key.request)
        response = try  block.extract(Key.response)
        maxAge   = try  block.extract(Key.maxAge)
        target   = try? block.extract(Key.target)
    }

    func createBlock(block: inout Block) {
        block.append(Key.request,  request)
        block.append(Key.response, response)
        block.append(Key.maxAge,   maxAge)
        block.append(Key.target,   target)
    }
}

extension RequestCache {
    
    @CompressedStringStorage("APGCacheStorage")
    private static var cacheStorage: String

    private static func store() {
        let block = cache.block
        Log("Storing \(cache.count)", enabled: logEnabled)
        cacheStorage = block.JSONString
    }
    
    static func restore() {

        if Network.cacheDisabled {
            Log("Request cache disabled", enabled: logEnabled)
            return
        }
        
        let json = cacheStorage
        if json.isEmpty || json == "{}" {
            Log("No cache", enabled: logEnabled)
            return
        }
        
        guard let parsedCache = try? [RequestCache](block: Block(string: json)) else {
            LogError("Failed to parse request cache")
            return
        }
        
        cache = parsedCache
        Log("\(cache.count) cached requests loaded.", enabled: logEnabled)

        for ca in parsedCache {
            Log(ca.request.url, enabled: logEnabled)
        }

    }
    
}

extension RequestCache {

    static func store(request: RequestInfo, response: CoreNetworkResponse, maxAge: Double, target: String?) {
        objc_sync_enter(self)
        Log("Storing \(request.url)", enabled: logEnabled)

        if let sameRequest = (cache.firstIndex { $0.request.tempHash == request.tempHash }) {
            Log("Deleting old", enabled: logEnabled)
            cache.remove(at: sameRequest)
        }

        cache.append(RequestCache(request: request, response: response, maxAge: maxAge, target: target))
        store()
        objc_sync_exit(self)
    }
    
    static func clearWhere(_ check: (RequestCache) -> (Bool)) {
        objc_sync_enter(self)
        cache.removeAll(where: check)
        store()
        objc_sync_exit(self)
    }

    static func getFor(_ request: RequestInfo) -> CoreNetworkResponse? {
        Log("Getting cache for: \(request.url)", enabled: logEnabled)
        guard let stored = (cache.first { $0.request.tempHash == request.tempHash }) else {
            Log("Fail", enabled: logEnabled)
            return nil
        }
        if stored.tooOld {
            Log("Too old", enabled: logEnabled)
            return nil
        }
        Log("OK. Age: \(stored.age)", enabled: logEnabled)
        return stored.response
    }

    static func dump() {
        Log("\(cache.count) cached requests stored.", enabled: logEnabled)
        for ca in cache {
            Log(ca.request.url, enabled: logEnabled)
        }
    }

    static func wipe() {
        cacheStorage = ""
    }

}

extension RequestCache {

    private static var cache: [RequestCache] = []

    var age: Double { request.age }
    var tooOld: Bool { age > maxAge && !Network.forceCache }

}

extension RequestCache {

    static func clearFor(_ identifier: RequestIdentifier) {
        clearWhere { identifier.match($0.request) }
    }

    static func clearFor(_ identifier: RequestIdentifier, _ object: Any) {
        clearWhere { identifier.match($0.request, object) }
    }

}