//
//  ArrayResponse.swift
//  yovape-merchant
//
//  Created by Vladas Zakrevskis on 10/19/17.
//  Copyright © 2017 almet-systems. All rights reserved.
//


public class ArrayResponse<T> : Response {
        
    typealias ArrayType = [T]
    
    public var array: [T] = []
    
    internal override init(response: CoreNetworkResponse) {
        super.init(response: response)
        if (error == nil) {
            if let _ = T.self as? BlockConvertible.Type {
                constructFromBlock(arc: T.self as! BlockConvertible.Type)
            }
        }
    }
    
    private func constructFromBlock(arc: BlockConvertible.Type) {
                
        guard let blockArray = block.toArray else { networkError = .failedToCreateBlock; return }
        
        for objectBlock in blockArray {
            if let object = try? arc.init(block: objectBlock) as? T {
                array.append(object)
            }
            else {
                LogError()
            }
        }
    }
}

