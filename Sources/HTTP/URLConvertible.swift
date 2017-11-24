//
//  URLConvertible.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 11/15/17.
//  Copyright © 2017 VladasZ. All rights reserved.
//

import Foundation

public func +(left: URLConvertible?, right: URLConvertible?) -> URLConvertible? {
    if left != nil && right == nil { return left! }
    if left == nil && right != nil { return right! }
    return left!.string.appending(right!.string)
}

public protocol URLConvertible {
    var url: URL? { get }
    var string: String { get }
}

extension String : URLConvertible {
    public var url: URL? { return URL(string: self) }
    public var string: String { return self }
}

extension URL : URLConvertible {
    public var url: URL? { return self }
    public var string: String { return self.path }
}
