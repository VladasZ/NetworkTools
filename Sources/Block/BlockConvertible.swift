//
//  BlockConvertible.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 6/14/17.
//  Copyright © 2017 VladasZ All rights reserved.
//

import Foundation


public protocol BlockConvertible : class, Parameters {
    
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
    
    var toString: String { block.JSONString }
    
    var toData: Data?                 { block.toData       }
    var toDictionary: [String : Any]? { block.toDictionary }
    
    init(block: Block?) throws {
        guard let block = block else { throw "No block" }
        try self.init(block: block)
    }
    
    init(data: Data?) throws {
        guard let data  = data              else { throw "FailedToInitializeBlockError()" }
        guard let block = Block(data: data) else { throw "FailedToInitializeBlockError()" }
        try self.init(block: block)
    }
    
}

public extension Array where Element: BlockConvertible {
    
    var block: Block {
        LogError()
        return Block.empty
    }
    
    init(data: Data?) throws {
        guard let data  = data              else { throw "FailedToInitializeBlockError()" }
        guard let block = Block(data: data) else { throw "FailedToInitializeBlockError()" }
        try self.init(block: block)
    }
    
    init(block: Block?) throws {
        
        guard let block = block else { throw "FailedToInitializeBlockError()" }
        
        let array = block.toArray ?? [block]
        var result = [Element]()

        array.forEach {
            if let element = try? Element(block: $0) { result.append(element) }
            else {
                if Network.logKeyExtractFailure {
                    LogError($0.JSONString)
                }
                if Network.verboseExtractLog {
                    LogError(block.JSONString)
                }
            }
        }
        
        if array.count != 0 && result.count == 0 { throw "FailedToInitializeBlockError()" }
        
        self = result
    }
    
    static func makeFrom(block: Block) -> Self? {
        try? Self(block: block)
    }
    
}

public extension Data {
    var JSONString: String {
        String(data: self, encoding: .utf8) ?? "not a JSON"
    }
}
