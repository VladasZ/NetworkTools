//
//  NetworkError.swift
//  NetworkTools
//
//  Created by Vladas Zakrevskis on 11/15/17.
//  Copyright © 2017 VladasZ. All rights reserved.
//

import Foundation

public enum NetworkError : Error, CustomStringConvertible {
    
    case invalidURL
    
    public var localizedDescription: String {
        return description
    }
    
    public var description: String {
        switch self {
        case .invalidURL: return "Invalid URL."
        }
    }
}
