//
//  NetworkInterface.swift
//
//
//  Created by Vladas Zakrevskis on 11/16/17.
//

internal typealias CoreRequestCompletion = (_ response: CoreNetworkResponse) -> ()

public typealias RequestCompletion = (_ response: Response) -> ()

public typealias ObjectCompletion<Result> = (_ response: ObjectResponse<Result>) -> ()

public typealias ObjectRequest<Result> = (_ completion: @escaping ObjectCompletion<Result>) -> ()

public typealias ParamRequest      <Param: Parameters>                           = (_ param: Param, _ completion: @escaping RequestCompletion)        -> ()
public typealias ParamObjectRequest<Param: Parameters, Result: BlockConvertible> = (_ param: Param, _ completion: @escaping ObjectCompletion<Result>) -> ()

public typealias Headers = [String : String]

public extension Network {
    
    static var baseURL: URLConvertible?
    static var defaultHeaders = Headers()

    static func request(_ url: URLConvertible,
                        method: HTTPMethod = .get,
                        cacheParams: CacheParams = .default,
                        urlEncodeParams: Bool = false
        ) -> Request
    {
        Request(cacheParams: cacheParams) { _cacheParams, completion in
            Network.coreRequest(url,
                                method: method,
                                headers: defaultHeaders,
                                cacheParams: _cacheParams,
                                urlEncodeParams: urlEncodeParams)
            { completion(Response(response: $0)) }
        }
    }

    static func request<Result: BlockConvertible>(_ url: URLConvertible,
                                                  method: HTTPMethod = .get,
                                                  resultType: Result.Type,
                                                  cacheParams: CacheParams = .default,
                                                  urlEncodeParams: Bool = false) -> ObjectRequest<Result>
    {
        { completion in
            Network.coreRequest(url,
                    method: method,
                    headers: defaultHeaders,
                    cacheParams: cacheParams,
                    urlEncodeParams: urlEncodeParams)
            { completion(ObjectResponse<Result>(response: $0)) }
        }
    }

    static func request<Params: Parameters>(_ url: URLConvertible,
                                            method: HTTPMethod = .get,
                                            paramsType: Params.Type,
                                            cacheParams: CacheParams = .default,
                                            urlEncodeParams: Bool = false
        ) -> ParamRequest<Params>
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
                                  urlEncodeParams: Bool = false) -> ParamObjectRequest<Params, Result>
    {
        { parameters, completion in
            Network.coreRequest(url,
                                method: method,
                                params: parameters,
                                headers: defaultHeaders,
                                cacheParams: cacheParams,
                                urlEncodeParams: urlEncodeParams)
            { completion(ObjectResponse<Result>(response: $0)) }
        }
    }

}
