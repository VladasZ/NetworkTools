//
//  SimpleResponse.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 10/13/17.
//  Copyright © 2017 Vladas Zakrevskis All rights reserved.
//

import SwiftyTools

public class SimpleResponse : ExpressibleByStringLiteral {
    
    public var error: NetworkError?
    public var block: Block = Block.empty
    
    public init() { }
    
    public init(error: String?) {
        if let error = error {
            self.error = .networkError(error)
        }
    }
    
    internal init(response: CoreNetworkResponse) {
        self.block = response.block ?? Block.empty
        self.error = response.error
    }
    
    //MARK: - ExpressibleByStringLiteral
    
    public required init(unicodeScalarLiteral: UnicodeScalar) { error = .networkError(String(unicodeScalarLiteral)) }
    public required init(extendedGraphemeClusterLiteral: Character) { error = .networkError(String(extendedGraphemeClusterLiteral)) }
    public required init(stringLiteral: String) { error = .networkError(String(stringLiteral)) }
}

