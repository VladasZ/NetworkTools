//
//  CacheParams.swift
//  Actors Pocket Guide
//
//  Created by Vladas Zakrevskis on 18.10.2020.
//  Copyright © 2020 Atomichronica. All rights reserved.
//

import Foundation


public class CacheParams {
    
    let enabled: Bool
    let maxAge: Double
    let forceGetFromCache: Bool
    
    init(enabled: Bool = true, maxAge: Double = 15, forceGetFromCache: Bool = false) {
        self.enabled = enabled
        self.maxAge  = maxAge
        self.forceGetFromCache = forceGetFromCache
    }

    var shouldCache: Bool {
        if Network.cacheDisabled { return false }
        return enabled || Network.forceCache
    }

    var shoudeGetFromCache: Bool {
        if Network.cacheDisabled { return false }
        return Connection.shared.notOk || forceGetFromCache
    }

    public static let enabled  = CacheParams()
    public static let disabled = CacheParams(enabled: false)

    public static var `default`: CacheParams {
        //.disabled
        CacheParams(enabled: Network.cacheEnabled)
    }

    public static func maxAge(_ age: Double) -> CacheParams {
        CacheParams(maxAge: age)
    }
    
}
