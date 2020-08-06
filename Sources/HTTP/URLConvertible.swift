//
//  URLConvertible.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 11/15/17.
//  Copyright © 2017 VladasZ. All rights reserved.
//

import Foundation


public func +(left: URLConvertible?, right: URLConvertible?) -> URLConvertible {
    if left != nil && right == nil { return left! }
    if left == nil && right != nil { return right! }
    return left!.toString.appending(right!.toString)
}

public protocol URLConvertible {
    var toUrl:    URL?   { get }
    var toString: String { get }
    var toFileURL: URL   { get }
}

extension String : URLConvertible {
    public var toUrl:     URL? { URL(string:          self) }
    public var toFileURL: URL  { URL(fileURLWithPath: self) }
}

extension URL : URLConvertible {
    public var toUrl:    URL?   {    self   }
    public var toString: String { "\(self)" }
    public var toFileURL: URL   {    self   }
}
