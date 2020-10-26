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
    
    init(enabled: Bool = true, maxAge: Double = 15) {
        self.enabled = enabled
        self.maxAge  = maxAge
    }


    public static let enabled  = CacheParams()
    public static let disabled = CacheParams(enabled: false)

    public static let `default`  = CacheParams.disabled


    public static func maxAge(_ age: Double) -> CacheParams {
        CacheParams(maxAge: age)
    }
    
}
