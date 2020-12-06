//
//  Request.swift
//  Actors Pocket Guide
//
//  Created by Vladas Zakrevskis on 21.10.2020.
//  Copyright © 2020 Atomichronica. All rights reserved.
//

import Foundation


public class Request<Params, Response> {
    
    public typealias Function
        = (_ cacheParams: CacheParams, _ params: Params?, _ completion: @escaping RequestCompletion<Response>) -> ()
    
    private var _cacheParams: CacheParams
    private var _params: Params?
    private let _function: Function
    
    init(cacheParams: CacheParams, _ function: @escaping Function) {
        _cacheParams = cacheParams
        _function    = function
    }
    
    func cache(_ cacheParams: CacheParams) -> Self {
        _cacheParams = cacheParams
        return self
    }

    func param(_ params: Params) -> Self {
        _params = params
        return self
    }
    
    func call(_ completion: @escaping RequestCompletion<Response>) {
        _function(_cacheParams, _params, completion)
    }
    
    func callAsFunction(_ completion: @escaping RequestCompletion<Response>) {
        _function(_cacheParams, _params, completion)
    }

    func call(_ params: Params, _ completion: @escaping RequestCompletion<Response>) {
        _params = params
        _function(_cacheParams, _params, completion)
    }

    func callAsFunction(_ params: Params, _ completion: @escaping RequestCompletion<Response>) {
        _params = params
        _function(_cacheParams, _params, completion)
    }
    
}
