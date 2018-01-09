//
// ObjectResponse.swift
//  yovape-merchant
//
//  Created by Vladas Zakrevskis on 10/13/17.
//  Copyright © 2017 almet-systems. All rights reserved.
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
