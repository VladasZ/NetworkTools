//
//  NetworkInterface.swift
//  
//
//  Created by Vladas Zakrevskis on 11/16/17.
//

import SwiftyTools

internal typealias CoreRequestCompletion = (_ response: CoreNetworkResponse) -> ()

public typealias RequestCompletion                                 = (_ response: Response)               -> ()
public typealias ObjectRequestCompletion<Result: BlockConvertible> = (_ response: ObjectResponse<Result>) -> ()
public typealias ArrayRequestCompletion<Result: BlockConvertible>  = (_ response: ArrayResponse<Result>)  -> ()

public typealias RequestFunction
    = (_ completion: @escaping RequestCompletion)               -> ()
public typealias ObjectRequestFunction<Result: BlockConvertible>
    = (_ completion: @escaping ObjectRequestCompletion<Result>) -> ()
public typealias ArrayRequestFunction<Result: BlockConvertible>
    = (_ completion: @escaping ArrayRequestCompletion<Result>)  -> ()

public typealias ParamRequestFunction<Params: Parameters>
    = (_ params: Params, _ completion: @escaping RequestCompletion)               -> ()
public typealias ParamObjectRequestFuction<Params: Parameters, Result: BlockConvertible>
    = (_ params: Params, _ completion: @escaping ObjectRequestCompletion<Result>) -> ()
public typealias ParamArrayRequestFuction<Params: Parameters, Result: BlockConvertible>
    = (_ params: Params, _ completion: @escaping ArrayRequestCompletion<Result>)  -> ()

public typealias Headers = [String : String]

public extension Network {
    
    public static var baseURL: URLConvertible?
    public static var defaultHeaders = Headers()
    
    public static func request<Params: Parameters>(_ url: URLConvertible,
                                                   method: HTTPMethod = .get,
                                                   paramsType: Params.Type
        ) -> ParamRequestFunction<Params>
    {
        return { parameters, completion in
            Network.coreRequest(url, method: method, params: parameters, headers: defaultHeaders)
            { completion(Response(response: $0)) }
        }
    }
    
    public static func request<
        Params: Parameters,
        Result: BlockConvertible>(_ url: URLConvertible,
                                  method: HTTPMethod = .get,
                                  paramsType: Params.Type,
                                  resultType: Result.Type) -> ParamObjectRequestFuction<Params, Result>
    {
        return { parameters, completion in
            Network.coreRequest(url, method: method, params: parameters, headers: defaultHeaders)
            { completion(ObjectResponse<Result>(response: $0)) }
        }
    }
    
    public static func request<
        Params: Parameters,
        Result: BlockConvertible>(_ url: URLConvertible,
                                  method: HTTPMethod = .get,
                                  paramsType: Params.Type,
                                  resultType: [Result].Type) -> ParamArrayRequestFuction<Params, Result>
    {
        return { parameters, completion in
            Network.coreRequest(url, method: method, params: parameters, headers: defaultHeaders)
            { completion(ArrayResponse<Result>(response: $0)) }
        }
    }
    
    public static func request(_ url: URLConvertible,
                               method: HTTPMethod = .get
        ) -> RequestFunction
    {
        return { completion in
            Network.coreRequest(url, method: method, headers: defaultHeaders)
            { completion(Response(response: $0)) }
        }
    }
    
    public static func request<Result: BlockConvertible>(_ url: URLConvertible,
                                                         method: HTTPMethod = .post,
                                                         resultType: Result.Type) -> ObjectRequestFunction<Result>
    {
        return { completion in
            Network.coreRequest(url, method: method, headers: defaultHeaders)
            { completion(ObjectResponse<Result>(response: $0)) }
        }
    }
    
    public static func request<Result: BlockConvertible>(_ url: URLConvertible,
                                                         method: HTTPMethod = .post,
                                                         resultType: [Result].Type) -> ArrayRequestFunction<Result>
    {
        return { completion in
            Network.coreRequest(url, method: method, headers: defaultHeaders)
            { completion(ArrayResponse<Result>(response: $0)) }
        }
    }
}

