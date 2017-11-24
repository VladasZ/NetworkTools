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
    case failedToCreateBlock
    case networkError(String)
    
    public var localizedDescription: String {
        return description
    }
    
    public var description: String {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .noData: return "No Data."
        case .failedToCreateBlock: return "Failed to create Block object from Data."
        case .networkError(let error): return error
        }
    }
}
