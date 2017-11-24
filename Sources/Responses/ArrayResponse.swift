//
//  ArrayResponse.swift
//  yovape-merchant
//
//  Created by Vladas Zakrevskis on 10/19/17.
//  Copyright © 2017 almet-systems. All rights reserved.
//

import SwiftyTools

public class ArrayResponse<Type> where Type: BlockConvertible {
    
    public var error: NetworkError?
    public var array: [Type] = []
    
    internal init(response: CoreNetworkResponse) {
        error = response.error
        if let block = response.block {
            if (error == nil) {
                guard let array = try? [Type](block: block) else { error = .failedToCreateBlock; return }
                self.array = array
            }
        }
    }
    
    public  init(error: String) {
        self.error = .networkError(error)
    }
}
