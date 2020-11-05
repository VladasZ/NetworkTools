//
//  Response.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 1/9/18.
//  Copyright © 2018 Vladas Zakrevskis. All rights reserved.
//

import Foundation


public class Response<T> {

    public var object: T!
    public var array: [T] = []


    public var requestURL:   URLConvertible
    public var method:       HTTPMethod
    public var responseCode: Int?
    public var networkError: NetworkError?
    public var block:        Block
    public var data:         String
    public var error:        String? { networkError?.localizedDescription }
    public var e:            String? { error } // ¯\_(ツ)_/¯

    internal init(response: CoreNetworkResponse) {
        requestURL   = response.requestURL
        method       = response.method
        responseCode = response.responseCode
        networkError = response.error
        block        = Block(string: response.data) ?? Block.empty
        data =       response.data

        if (error == nil) {
            if let _ = T.self as? BlockConvertible.Type {
                constructFromBlock(type: T.self as! BlockConvertible.Type)
            }
            else {
             //   LogError()
            }
        }

    }

    //MARK: - Objects response

    private func constructFromBlock(type: BlockConvertible.Type) {
        if let blockArray = block.toArray {
            constructArray(blockArray: blockArray, type: type)
        }
        else {
            constructObject(type: type)
        }
    }

    private func constructArray(blockArray: [Block], type: BlockConvertible.Type) {
        for objectBlock in blockArray {
            if let object = try? type.init(block: objectBlock) as? T {
                array.append(object)
            }
            else {
                LogError()
            }
        }
        if !array.isEmpty {
            object = array.first!
        }
    }

    private func constructObject(type: BlockConvertible.Type) {
        guard let _object = try? type.init(block: block) as? T else {
            networkError = .failedToCreateBlock
            return
        }
        object = _object
    }

}
