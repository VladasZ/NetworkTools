//
//  BlockConvertible.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 6/14/17.
//  Copyright © 2017 VladasZ All rights reserved.
//

import SwiftyTools

public protocol BlockConvertible : Parameters {
    
    init(data: Data?) throws
    init(block: Block) throws
    
    func createBlock(block: inout Block)
}

public extension BlockConvertible {
    
    var block: Block {
        var block = Block()
        createBlock(block: &block)
        return block
    }
    
    var String: String? {
        return block.JSONString
    }
    
    var data: Data?                 { return block.data       }
    var dictionary: [String : Any]? { return block.dictionary }
    
    init(block: Block?) throws {
        guard let block = block else { throw "No block" }
        try self.init(block: block)
    }
    
    init(data: Data?) throws {
        
        guard let data = data else { throw "FailedToInitializeBlockError()" }
        guard let block = Block(data: data) else { throw "FailedToInitializeBlockError()" }
        try self.init(block: block)
    }
}

public extension Array where Element: BlockConvertible {
    
    var block: Block {
        
        LogError()
        return Block.empty//map { $0.block }
    }
    
    init(data: Data?) throws {
        
        guard let data = data else { throw "FailedToInitializeBlockError()" }
        guard let block = Block(data: data) else { throw "FailedToInitializeBlockError()" }
        try self.init(block: block)
    }
    
    init(block: Block?) throws {
        
        guard let block = block else { throw "FailedToInitializeBlockError()" }
        
        let array = block.array ?? [block]
        var result = [Element]()

        array.forEach {
            
            if let element = try? Element(block: $0) { result.append(element) }
            else {
                
                LogError()
            }
        }
        
        if array.count != 0 && result.count == 0 { throw "FailedToInitializeBlockError()" }
        
        self = result
    }
}

public extension Data {
    var JSONString: String {
        return String(data: self, encoding: .utf8) ?? "not a JSON"
    }
}
