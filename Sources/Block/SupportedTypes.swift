//
//  SupportedTypes.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 6/15/17.
//  Copyright © 2017 VladasZ All rights reserved.
//

import Foundation

public protocol BlockSupportedType { }

extension Bool   : BlockSupportedType { }
extension Int    : BlockSupportedType { }
extension Double : BlockSupportedType { }
extension String : BlockSupportedType { }


public protocol DefaultInitializable {
    static var defaultValue: Self { get }
}

extension Bool   : DefaultInitializable {
    public static var defaultValue: Bool   { return Bool()   }
}

extension Int    : DefaultInitializable {
    public static var defaultValue: Int    { return Int()    }
}

extension Double : DefaultInitializable {
    public static var defaultValue: Double { return Double() }
}

extension String : DefaultInitializable {
    public static var defaultValue: String { return Swift.String() }
}

extension Dictionary : DefaultInitializable {
    public static var defaultValue: Dictionary { return [:] }
}
