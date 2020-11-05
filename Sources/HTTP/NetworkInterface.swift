//
//  NetworkInterface.swift
//
//
//  Created by Vladas Zakrevskis on 11/16/17.
//

internal typealias CoreRequestCompletion = (_ response: CoreNetworkResponse) -> ()

public typealias RequestCompletion<Result> = (_ response: Response<Result>) -> ()
public typealias SimpleCompletion = RequestCompletion<Void>

public typealias ParamRequest<Param: Parameters, Result> = (_ param: Param, _ completion: @escaping RequestCompletion<Result>) -> ()

public typealias Headers = [String : String]

public extension Network {
    
    static var baseURL: URLConvertible?
    static var defaultHeaders = Headers()

    static func request(_ url: URLConvertible,
                        method: HTTPMethod = .get,
                        cacheParams: CacheParams = .default,
                        urlEncodeParams: Bool = false
        ) -> Request<Void>
    {
        Request(cacheParams: cacheParams) { _cacheParams, completion in
            Network.coreRequest(url,
                                method: method,
                                headers: defaultHeaders,
                                cacheParams: _cacheParams,
                                urlEncodeParams: urlEncodeParams)
            { completion(Response<Void>(response: $0)) }
        }
    }

    static func request<Result>(_ url: URLConvertible,
                                method: HTTPMethod = .get,
                                resultType: Result.Type,
                                cacheParams: CacheParams = .default,
                                urlEncodeParams: Bool = false) -> Request<Result>
    {
        Request<Result>(cacheParams: cacheParams) { _cacheParams, completion in
            Network.coreRequest(url,
                    method: method,
                    headers: defaultHeaders,
                    cacheParams: _cacheParams,
                    urlEncodeParams: urlEncodeParams)
            { completion(Response<Result>(response: $0)) }
        }
    }

    static func request<Params: Parameters>(_ url: URLConvertible,
                                            method: HTTPMethod = .get,
                                            paramsType: Params.Type,
                                            cacheParams: CacheParams = .default,
                                            urlEncodeParams: Bool = false
        ) -> ParamRequest<Params, Void>
    {
        { parameters, completion in
            Network.coreRequest(url,
                                method: method,
                                params: parameters,
                                headers: defaultHeaders,
                                cacheParams: cacheParams,
                                urlEncodeParams: urlEncodeParams)
            { completion(Response(response: $0)) }
        }
    }
    
    static func request<
        Params: Parameters,
        Result: BlockConvertible>(_ url: URLConvertible,
                                  method: HTTPMethod = .get,
                                  paramsType: Params.Type,
                                  resultType: Result.Type,
                                  cacheParams: CacheParams = .default,
                                  urlEncodeParams: Bool = false) -> ParamRequest<Params, Result>
    {
        { parameters, completion in
            Network.coreRequest(url,
                                method: method,
                                params: parameters,
                                headers: defaultHeaders,
                                cacheParams: cacheParams,
                                urlEncodeParams: urlEncodeParams)
            { completion(Response<Result>(response: $0)) }
        }
    }

}
