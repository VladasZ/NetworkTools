//
//  ObjectResponse.swift
//  yovape-merchant
//
//  Created by Vladas Zakrevskis on 10/19/17.
//  Copyright © 2017 almet-systems. All rights reserved.
//


public class ObjectResponse<T> : Response {

    public var object: T!
    public var array: [T] = []
    
    internal override init(response: CoreNetworkResponse) {
        super.init(response: response)
        if (error == nil) {
            if let _ = T.self as? BlockConvertible.Type {
                constructFromBlock(type: T.self as! BlockConvertible.Type)
            }
            else {
                LogError()
            }
        }
    }
    
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
