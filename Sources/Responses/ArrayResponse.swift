//
//  ArrayResponse.swift
//  yovape-merchant
//
//  Created by Vladas Zakrevskis on 10/19/17.
//  Copyright © 2017 almet-systems. All rights reserved.
//

import SwiftyTools

public class ArrayResponse<Type: BlockConvertible> : Response {
    
    public var array: [Type] = []
    
    internal override init(response: CoreNetworkResponse) {
        super.init(response: response)
        if (error == nil) {
            guard let array = try? [Type](block: block) else { error = .failedToCreateBlock; return }
            self.array = array
        }
    }
}
