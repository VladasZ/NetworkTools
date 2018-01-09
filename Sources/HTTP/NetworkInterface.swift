//
//  NetworkInterface.swift
//  
//
//  Created by Vladas Zakrevskis on 11/16/17.
//

import SwiftyTools

internal typealias CoreRequestCompletion = (_ response: CoreNetworkResponse) -> ()

public typealias ObjectRequestCompletion<T: BlockConvertible> = (_ response: ObjectResponse<T>) -> ()
public typealias ArrayRequestCompletion<T: BlockConvertible> = (_ response: ArrayResponse<T>) -> ()

public typealias ArrayRequest<T: BlockConvertible> = (@escaping (ArrayResponse<T>) -> ()) -> ()
public typealias RequestCompletion = (_ response: Response) -> ()

public typealias RequestFunction = (_ completion: @escaping RequestCompletion) -> ()
public typealias ObjectRequestFunction<T: BlockConvertible> = (_ completion: @escaping ObjectRequestCompletion<T>) -> ()
public typealias ArrayRequestFunction<T: BlockConvertible> = (_ completion: @escaping ArrayRequestCompletion<T>) -> ()

public typealias Headers = [String : String]

public extension Network {
    
    public static var baseURL: URLConvertible?
    public static var headers = Headers()
    
    public static func request(_ url: URLConvertible,
                               method: HTTPMethod = .post
                               //headers: Headers = [:]
        ) -> RequestFunction {
        return { completion in
            Network.coreRequest(url, method: method, headers: headers)
            { completion(Response(response: $0)) }
        }
    }
    
    public static func request<T: BlockConvertible>(_ url: URLConvertible,
                                  method: HTTPMethod = .post,
                                  //headers: Headers = [:],
                                  _ type: T.Type) -> ObjectRequestFunction<T> {
        return { completion in
            Network.coreRequest(url, method: method, headers: headers)
            { completion(ObjectResponse<T>(response: $0)) }
        }
    }
    
    public static func request<T: BlockConvertible>(_ url: URLConvertible,
                                  method: HTTPMethod = .post,
                                  //headers: Headers = [:],
                                  _ type: [T].Type) -> ArrayRequestFunction<T>{
        return { completion in
            Network.coreRequest(url, method: method, headers: headers)
            { completion(ArrayResponse<T>(response: $0)) }
        }
    }
}

