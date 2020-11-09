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
    
    init(enabled: Bool = true, maxAge: Double = 150000) {
        self.enabled = enabled
        self.maxAge  = maxAge
    }

    var shouldCache: Bool {
        if Network.cacheDisabled { return false }
        return enabled || Network.forceCache
    }

    var shoudeGetFromCache: Bool {
        if Network.cacheDisabled { return false }
        if Connection.ok { return false }
        return enabled || Network.forceCache
    }

    public static let enabled  = CacheParams()
    public static let disabled = CacheParams(enabled: false)

    public static let `default` = CacheParams.disabled

    public static func maxAge(_ age: Double) -> CacheParams {
        CacheParams(maxAge: age)
    }
    
}
