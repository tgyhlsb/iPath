//
//  BackendManager.swift
//  iPath
//
//  Created by Tanguy Hélesbeux on 09/10/2016.
//  Copyright © 2016 Tanguy Helesbeux. All rights reserved.
//

import UIKit
import Alamofire

public enum Result<T> {
    case success(data: T)
    case failure(error: Error?)
}

class BackendManager {
    
    // MARK: - PUBLIC -
    
    // MARK: Init
    
    public init(domain: String, secret: String) {
        self.domain = domain
        self.secret = secret
    }
    
    // MARK: Requests
    
    public func requestNewRoute(completion: @escaping (Result<String>) -> Void) {
        
        self.request(.token) { (response) in
            switch response.result {
            case .success(let data):
                guard let json = data as? NSDictionary, let token = json.object(forKey: "token") as? String else {
                    completion(.failure(error: nil))
                    break
                }
                completion(.success(data: token))
            case .failure(let error): print(error)
                completion(.failure(error: error))
            }
        }
    }
    
    public func fetchRoute(token: String, completion: @escaping (Result<Route>) -> Void) {
        self.request(.route(token: token)) { (response) in
            switch response.result {
            case .success(let data):
                guard let json = data as? NSArray else {
                    return completion(.failure(error: nil))
                }
                let route = Route(json: json)
                return completion(.success(data: route))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    // MARK: - INTERNAL -
    
    // MARK: - PRIVATE -
    
    private let domain: String
    private let secret: String
    
    private func headers() -> [String: String] {
        return [
            "x-api-key": "Ohe0CvYvMc86pJfv7k6u"
        ]
    }
    
    private func request(_ endpoint: EndPoint, completion: @escaping (DataResponse<Any>) -> Void) {
        let url = self.domain + endpoint.path
        Alamofire.request(url, method: endpoint.method, headers: self.headers()).responseJSON { (response) in
            completion(response)
        }
    }
    
}
