//
//  RequestIdentifier.swift
//  Actors Pocket Guide
//
//  Created by Vladas Zakrevskis on 02.03.2021.
//  Copyright © 2021 Atomichronica. All rights reserved.
//

import Foundation

typealias MatchRequest           = (RequestInfo           ) -> (Bool)
typealias MatchRequestWithObject = (RequestInfo, Any) -> (Bool)

class RequestIdentifier {
    
    private let justMatch: MatchRequest!
    private let objectMatch: MatchRequestWithObject!
    
    init(_ match: @escaping MatchRequest) {
        justMatch = match
        objectMatch = nil
    }
    
    init(_ match: @escaping MatchRequestWithObject) {
        justMatch = nil
        objectMatch = match
    }

    func match(_ request: RequestInfo) -> Bool {
        justMatch(request)
    }

    func match(_ request: RequestInfo, _ object: Any) -> Bool {
        objectMatch(request, object)
    }
    
}
