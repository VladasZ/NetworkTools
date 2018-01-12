//
// ObjectResponse.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 1/9/18.
//  Copyright © 2018 Vladas Zakrevskis. All rights reserved.
//

import SwiftyTools

public class ObjectResponse<Type: BlockConvertible> : Response {
    
    public var object: Type!
    
    internal override init(response: CoreNetworkResponse) {
        super.init(response: response)
        
        if (error == nil) {
            object = try? Type(block: block)
            if object == nil { error = .failedToCreateBlock }
        }
    }
}
