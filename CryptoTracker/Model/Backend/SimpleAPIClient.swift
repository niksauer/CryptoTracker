//
//  SimpleAPIClient.swift
//  CryptoTracker
//
//  Created by Niklas Sauer on 03.04.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Foundation

struct SimpleAPIClient: APIClient {
    
    // MARK: - Public Properties
    let baseURL: String
    let credentials: APICredentialStore?
    
    // MARK: - Private Properties
    private let session = URLSession(configuration: .default)
    
    // MARK: - Public Methods
    func makeGETRequest(to path: String? = nil, params: JSON? = nil, completion: @escaping (APIResult) -> Void) {
        let url = URL(baseURL: baseURL, path: path, params: params)
        let request = URLRequest(url: url, method: .get)
        
        executeSessionDataTask(request: request, completion: completion)
    }
    
    func makePOSTRequest<T: Encodable>(to path: String? = nil, params: JSON? = nil, body: T, completion: @escaping (APIResult) -> Void) throws {
        let url = URL(baseURL: baseURL, path: path, params: nil)
        let request = try URLRequest(url: url, method: .post, body: body)
        
        executeSessionDataTask(request: request, completion: completion)
    }
    
    func makePUTRequest<T: Encodable>(to path: String? = nil, params: JSON? = nil, body: T, completion: @escaping (APIResult) -> Void) throws {
        let url = URL(baseURL: baseURL, path: path, params: nil)
        let request = try URLRequest(url: url, method: .put, body: body)
        
        executeSessionDataTask(request: request, completion: completion)
    }
    
    func makeDELETERequest(to path: String? = nil, params: JSON? = nil, completion: @escaping (APIResult) -> Void) {
        let url = URL(baseURL: baseURL, path: path, params: nil)
        let request = URLRequest(url: url, method: .delete)
        
        executeSessionDataTask(request: request, completion: completion)
    }
    
    // MARK: - Private Methods
    private func executeSessionDataTask(request: URLRequest, completion: @escaping (APIResult) -> Void) {
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            let result: APIResult
            
            if let data = data {
                result = APIResult.success(data)
            } else {
                result = APIResult.failure(error!)
            }
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        
        task.resume()
    }
    
}
