//
//  NetworkInterface.swift
//
//
//  Created by Vladas Zakrevskis on 11/16/17.
//


internal typealias CoreRequestCompletion = (_ response: CoreNetworkResponse) -> ()

public typealias RequestCompletion               = (_ response: Response)               -> ()
public typealias ObjectRequestCompletion<Result> = (_ response: ObjectResponse<Result>) -> ()
public typealias ArrayRequestCompletion<Result>  = (_ response: ArrayResponse<Result>)  -> ()

public typealias RequestFunction
    = (_ completion: @escaping RequestCompletion)               -> ()
public typealias ObjectRequestFunction<Result>
    = (_ completion: @escaping ObjectRequestCompletion<Result>) -> ()
public typealias ArrayRequestFunction<Result>
    = (_ completion: @escaping ArrayRequestCompletion<Result>)  -> ()

public typealias ParamRequestFunction<Params: Parameters>
    = (_ params: Params, _ completion: @escaping RequestCompletion)               -> ()
public typealias ParamObjectRequestFuction<Params: Parameters, Result: BlockConvertible>
    = (_ params: Params, _ completion: @escaping ObjectRequestCompletion<Result>) -> ()
public typealias ParamArrayRequestFuction<Params: Parameters, Result: BlockConvertible>
    = (_ params: Params, _ completion: @escaping ArrayRequestCompletion<Result>)  -> ()

public typealias Headers = [String : String]

public extension Network {
    
    static var baseURL: URLConvertible?
    static var defaultHeaders = Headers()
    
    static func request<Params: Parameters>(_ url: URLConvertible,
                                            method: HTTPMethod = .get,
                                            paramsType: Params.Type,
                                            urlEncodeParams: Bool = false
        ) -> ParamRequestFunction<Params>
    {
        return { parameters, completion in
            Network.coreRequest(url, method: method, params: parameters, headers: defaultHeaders, urlEncodeParams: urlEncodeParams)
            { completion(Response(response: $0)) }
        }
    }
    
    static func request<
        Params: Parameters,
        Result: BlockConvertible>(_ url: URLConvertible,
                                  method: HTTPMethod = .get,
                                  paramsType: Params.Type,
                                  resultType: Result.Type,
                                  urlEncodeParams: Bool = false) -> ParamObjectRequestFuction<Params, Result>
    {
        return { parameters, completion in
            Network.coreRequest(url, method: method, params: parameters, headers: defaultHeaders, urlEncodeParams: urlEncodeParams)
            { completion(ObjectResponse<Result>(response: $0)) }
        }
    }
    
    static func request<
        Params: Parameters,
        Result: BlockConvertible>(_ url: URLConvertible,
                                  method: HTTPMethod = .get,
                                  paramsType: Params.Type,
                                  resultType: [Result].Type,
                                  urlEncodeParams: Bool = false) -> ParamArrayRequestFuction<Params, Result>
    {
        return { parameters, completion in
            Network.coreRequest(url, method: method, params: parameters, headers: defaultHeaders, urlEncodeParams: urlEncodeParams)
            { completion(ArrayResponse<Result>(response: $0)) }
        }
    }
    
    static func request(_ url: URLConvertible,
                        method: HTTPMethod = .get,
                        urlEncodeParams: Bool = false
        ) -> RequestFunction
    {
        return { completion in
            Network.coreRequest(url, method: method, headers: defaultHeaders, urlEncodeParams: urlEncodeParams)
            { completion(Response(response: $0)) }
        }
    }
    
    static func request<Result: BlockConvertible>(_ url: URLConvertible,
                                                  method: HTTPMethod = .get,
                                                  resultType: Result.Type,
                                                  urlEncodeParams: Bool = false) -> ObjectRequestFunction<Result>
    {
        return { completion in
            Network.coreRequest(url, method: method, headers: defaultHeaders, urlEncodeParams: urlEncodeParams)
            { completion(ObjectResponse<Result>(response: $0)) }
        }
    }
    
    static func request<Result: BlockConvertible>(_ url: URLConvertible,
                                                  method: HTTPMethod = .get,
                                                  resultType: [Result].Type,
                                                  urlEncodeParams: Bool = false) -> ArrayRequestFunction<Result>
    {
        return { completion in
            Network.coreRequest(url, method: method, headers: defaultHeaders, urlEncodeParams: urlEncodeParams)
            { completion(ArrayResponse<Result>(response: $0)) }
        }
    }
}
