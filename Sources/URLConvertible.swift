//
//  URLConvertible.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 11/15/17.
//  Copyright © 2017 VladasZ. All rights reserved.
//

import Foundation

public protocol URLConvertible {
    var url: URL? { get }
}

extension String : URLConvertible {
    public var url: URL? { return URL(string: self) }
}

extension URL : URLConvertible {
    public var url: URL? { return self }
}
