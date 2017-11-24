//
//  NetworkInterface.swift
//  
//
//  Created by Vladas Zakrevskis on 11/16/17.
//

import SwiftyTools

internal typealias CoreRequestCompletion    = (_ response: CoreNetworkResponse) -> ()

public typealias ObjectRequestCompletion<T> = (_ response: ObjectResponse<T>)   -> () where T: BlockConvertible
public typealias ArrayRequestCompletion<T>  = (_ response: ArrayResponse<T>)    -> () where T: BlockConvertible

public typealias ArrayRequest<T> = (@escaping (ArrayResponse<T>) -> ()) -> () where T: BlockConvertible
public typealias RequestCompletion = (_ response: SimpleResponse) -> ()


public typealias RequestFunction = (_ completion: @escaping RequestCompletion) -> ()
public typealias ObjectRequestFunction<T> = (_ completion: @escaping ObjectRequestCompletion<T>) -> () where T: BlockConvertible
public typealias ArrayRequestFunction<T> = (_ completion: @escaping ArrayRequestCompletion<T>) -> () where T: BlockConvertible


public typealias Headers = [String : String]

public extension Network {
    
    public static var baseURL: URLConvertible?
    public static var headers = Headers()
    
    public static func request(_ url: URLConvertible? = nil,
                               method: HTTPMethod = .post
                               //headers: Headers = [:]
        ) -> RequestFunction {
        return { completion in
            Network.coreRequest(url, method: method, headers: headers)
            { completion(SimpleResponse(response: $0)) }
        }
    }
    
    public static func request<T>(_ url: URLConvertible? = nil,
                                  method: HTTPMethod = .post,
                                  //headers: Headers = [:],
                                  _ type: T.Type) -> ObjectRequestFunction<T> where T: BlockConvertible {
        return { completion in
            Network.coreRequest(url, method: method, headers: headers)
            { completion(ObjectResponse<T>(response: $0)) }
        }
    }
    
    public static func request<T>(_ url: URLConvertible? = nil,
                                  method: HTTPMethod = .post,
                                  //headers: Headers = [:],
                                  _ type: [T].Type) -> ArrayRequestFunction<T> where T: BlockConvertible {
        return { completion in
            Network.coreRequest(url, method: method, headers: headers)
            { completion(ArrayResponse<T>(response: $0)) }
        }
    }
}

