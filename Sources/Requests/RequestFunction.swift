//
//  NewRequestFunction.swift
//  Actors Pocket Guide
//
//  Created by Vladas Zakrevskis on 21.10.2020.
//  Copyright © 2020 Atomichronica. All rights reserved.
//

import Foundation


public class RequestFunction {
    
    public typealias Function
        = (_ cacheParams: CacheParams, _ completion: @escaping RequestCompletion) -> ()
    
    private var _cacheParams: CacheParams
    private let _function: Function
    
    init(cacheParams: CacheParams, _ function: @escaping Function) {
        _cacheParams = cacheParams
        _function    = function
    }
    
    func cache(_ cacheParams: CacheParams) -> Self {
        _cacheParams = cacheParams
        return self
    }
    
    func call(_ completion: @escaping RequestCompletion) {
        _function(_cacheParams, completion)
    }
    
    func callAsFunction(_ completion: @escaping RequestCompletion) {
        _function(_cacheParams, completion)
    }
    
}
