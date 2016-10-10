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
    case failure(error: String)
}

class BackendManager {
    
    // MARK: - PUBLIC -
    
    // MARK: Init
    
    public init(domain: String, secret: String) {
        self.domain = domain
        self.secret = secret
    }
    
    // MARK: Requests
    
    public func createRoute(completion: @escaping (Result<String>) -> Void) {
        self.request(.token) { (result: Result<NSDictionary>) in
            switch result {
            case .failure(let err):
                completion(.failure(error: err))
            case .success(let data):
                completion(self.token(from: data))
            }
        }
    }
    
    public func fetchRoute(token: String, completion: @escaping (Result<Route>) -> Void) {
        self.request(.route(token: token)) { (result: Result<NSArray>) in
            switch result {
            case .failure(let err):
                completion(.failure(error: err))
            case .success(let data):
                completion(self.route(token: token, from: data))
            }
        }
    }
    
    // MARK: - INTERNAL -
    
    // MARK: - PRIVATE -
    
    private let domain: String
    private let secret: String
    
    private func headers() -> [String: String] {
        return [
            "x-api-key": self.secret
        ]
    }
    
    private func request<T>(_ endpoint: EndPoint, completion: @escaping (Result<T>) -> Void) {
        let url = self.domain + endpoint.path
        Alamofire.request(url, method: endpoint.method, headers: self.headers()).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                completion(.failure(error: error.localizedDescription))
            case .success(let value):
                guard let json = value as? T else {
                    return completion(.failure(error: "Could not read response"))
                }
                completion(.success(data: json))
            }
        }
    }
    
    private func token(from json: NSDictionary) -> Result<String> {
        guard let token = json.object(forKey: "token") as? String else { return .failure(error: "Could not read token") }
        return .success(data: token)
    }
    
    private func route(token: String, from json: NSArray) -> Result<Route> {
        guard let route = Route(token: token, json: json) else {
            return .failure(error: "Failed to instantiate Route.")
        }
        return .success(data: route)
    }
    
}
