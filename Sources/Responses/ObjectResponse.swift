//
// ObjectResponse.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 1/9/18.
//  Copyright © 2018 Vladas Zakrevskis. All rights reserved.
//


public class ObjectResponse<T> : Response {
    
    public var object: T!
    
    internal override init(response: CoreNetworkResponse) {
        super.init(response: response)
        
        if (error == nil) {
            if let _ = T.self as? BlockConvertible.Type {
                constructFromBlock(arc: T.self as! BlockConvertible.Type)
            }
        }
    }
    
    
    private func spes(arc: Mappable.Type) {
                
    }
    
    private func constructFromBlock(arc: BlockConvertible.Type) {
        object = try? arc.init(block: block) as? T
        if object == nil { networkError = .failedToCreateBlock }
    }
    
}

