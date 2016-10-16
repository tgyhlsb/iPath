//
//  EndPoint.swift
//  iPath
//
//  Created by Tanguy Hélesbeux on 09/10/2016.
//  Copyright © 2016 Tanguy Helesbeux. All rights reserved.
//

import Foundation
import Alamofire

enum EndPoint {
    
    case token
    case route(token: String)
    case mapList
    case mapDetail(name: String)
    
    var path: String {
        switch self {
        case .token: return "/token/new"
        case .route(let token): return "/route/\(token)"
        case .mapList: return "/map"
        case .mapDetail(let name): return "/map/\(name)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .route(_): return .post
        default: return .get
        }
    }
    
}
