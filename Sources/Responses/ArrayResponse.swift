//
//  ArrayResponse.swift
//  yovape-merchant
//
//  Created by Vladas Zakrevskis on 10/19/17.
//  Copyright © 2017 almet-systems. All rights reserved.
//


public class ArrayResponse<T> : Response {
            
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
                
        guard let blockArray = block.toArray else { networkError = .failedToCreateBlock; return }
        
        for objectBlock in blockArray {
            if let object = try? type.init(block: objectBlock) as? T {
                array.append(object)
            }
            else {
                LogError()
            }
        }
    }
}
