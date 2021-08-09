//
//  NetworkInterface.swift
//
//
//  Created by Vladas Zakrevskis on 11/16/17.
//

import Foundation

internal typealias CoreRequestCompletion = (_ response: CoreNetworkResponse) -> ()

public typealias RequestCompletion<Result> = (_ response: Response<Result>) -> ()
public typealias SimpleCompletion = RequestCompletion<Void>
public typealias DownloadCompletion = (_ tempUrl: URL?, _ response: URLResponse?, _ error: String?) -> ()

public typealias ParamRequest<Param: Parameters, Result> = (_ param: Param, _ completion: @escaping RequestCompletion<Result>) -> ()

public typealias Headers = [String : String]

public extension Network {
    
    static var baseURL: URLConvertible?
    static var defaultHeaders = Headers()
    
    static func download(_ url: URLConvertible, _ completion: @escaping DownloadCompletion) {
        Network.downloadRequest(url, headers: defaultHeaders, completion)
    }

    static func request(_ url: URLConvertible,
                        method: HTTPMethod = .get,
                        cacheParams: CacheParams = .default,
                        urlEncodeParams: Bool = false
        ) -> Request<Void, Void>
    {
        Request(cacheParams: cacheParams) { _cacheParams, _, completion in
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
                                urlEncodeParams: Bool = false) -> Request<Void, Result>
    {
        Request(cacheParams: cacheParams) { _cacheParams, _, completion in
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
        ) -> Request<Params, Void>
    {
        Request(cacheParams: cacheParams) { _cacheParams, parameters, completion in
            Network.coreRequest(url,
                                method: method,
                                params: parameters,
                                headers: defaultHeaders,
                                cacheParams: _cacheParams,
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
                                  urlEncodeParams: Bool = false) -> Request<Params, Result>
    {
        Request(cacheParams: cacheParams) { _cacheParams, parameters, completion in
            Network.coreRequest(url,
                                method: method,
                                params: parameters,
                                headers: defaultHeaders,
                                cacheParams: _cacheParams,
                                urlEncodeParams: urlEncodeParams)
            { completion(Response<Result>(response: $0)) }
        }
    }

}
