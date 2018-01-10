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
    case noData
    case noParams
    case failedToCreateBlock
    case notImplemented
    case networkError(String)
    
    public var localizedDescription: String {
        return description
    }
    
    public var description: String {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .noData: return "No Data."
        case .noParams: return "No Parameters."
        case .failedToCreateBlock: return "Failed to create Block object from Data."
        case .notImplemented: return "Not Implemented."
        case .networkError(let error): return error
        }
    }
}
