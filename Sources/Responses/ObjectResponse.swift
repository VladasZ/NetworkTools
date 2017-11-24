//
// ObjectResponse.swift
//  yovape-merchant
//
//  Created by Vladas Zakrevskis on 10/13/17.
//  Copyright © 2017 almet-systems. All rights reserved.
//

import SwiftyTools

public class ObjectResponse<Type> where Type: BlockConvertible {
    
    public var error: NetworkError?
    public var object: Type!
    
    internal init(response: CoreNetworkResponse) {
        self.error = response.error
        if let block = response.block {
            if (error == nil) {
                object = try? Type(block: block)
                if object == nil { error = .failedToCreateBlock }
            }           
        }
    }
    
    init(error: String) {
        self.error = .networkError(error)
    }
}
