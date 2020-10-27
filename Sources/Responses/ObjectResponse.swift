//
// ObjectResponse.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 1/9/18.
//  Copyright © 2018 Vladas Zakrevskis. All rights reserved.
//

public protocol TypeStoring {
    associatedtype SomeType
}


public class ObjectResponse<T> : Response {
    
    public var object: T!
    
    internal override init(response: CoreNetworkResponse) {
        super.init(response: response)
        
        if (error == nil) {
            if T.self is BlockConvertible.Type {
                constructObjectFromBlock(type: T.self as! BlockConvertible.Type)
            }
            else if T.self is Array<BlockConvertible>.Type {
                constructArrayFromBlock(type: T.self as! Array<BlockConvertible>.Element.Type)
            }
            else {
                LogError()
                fatalError()
            }
        }
    }
    
    private func constructObjectFromBlock(type: BlockConvertible.Type) {
        LogWarning("Abjilka")
        object = try? type.init(block: block) as? T
        if object == nil { networkError = .failedToCreateBlock }
    }

    private func constructArrayFromBlock(type: BlockConvertible.Type) {

        LogWarning("Orakul!")

        object = [] as! T

        let aspekt = try? type.init(block: block)

//        for objectBlock in blockArray {
//            if let object = try? type.Element.init(block: objectBlock) as? T {
//                //array.append(object)
//            }
//            else {
//                LogError()
//            }
//        }


//        object = try? type.init(block: block) as? T
//        if object == nil { networkError = .failedToCreateBlock }
    }

//    private func constructFromBlock(type: BlockConvertible.Type) {
//        object = try? type.init(block: block) as? T
//        if object == nil { networkError = .failedToCreateBlock }
//    }
    
}

