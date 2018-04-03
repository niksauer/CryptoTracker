//
//  APIClient.swift
//  RoadChat
//
//  Created by Niklas Sauer on 11.03.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

enum APIResult {
    case success(Data?)
    case failure(Error)
}

protocol APICredentialStore {
    func getUserID() -> Int?
    func setUserID(_ userID: Int?) throws
    func getToken() -> String?
    func setToken(_ token: String?) throws
    func reset() throws
}

protocol APIClient {
    var baseURL: String { get }
    var credentials: APICredentialStore? { get }
    
    init(baseURL: String, credentials: APICredentialStore?)
    
    func makeGETRequest(to path: String?, params: JSON?, completion: @escaping (APIResult) -> Void)
    func makePOSTRequest<T: Encodable>(to path: String?, params: JSON?, body: T, completion: @escaping (APIResult) -> Void) throws
    func makePUTRequest<T: Encodable>(to path: String?, params: JSON?, body: T, completion: @escaping (APIResult) -> Void) throws
    func makeDELETERequest(to path: String?, params: JSON?, completion: @escaping (APIResult) -> Void)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension URL {
    init(baseURL: String, path: String?, params: JSON?) {
        var components = URLComponents(string: "\(baseURL)\(path ?? "")")!
        var queryItems = [URLQueryItem]()
        
        if let params = params {
            for (key, value) in params {
                let queryItem = URLQueryItem(name: key, value: String(describing: value))
                queryItems.append(queryItem)
            }
        }
        
        components.queryItems = queryItems
        self = components.url!
    }
}

extension URLRequest {
    init(url: URL, method: HTTPMethod) {
        self.init(url: url)
        
        // set http method
        httpMethod = method.rawValue
    }
    
    init<T: Encodable>(url: URL, method: HTTPMethod, body: T) throws {
        self.init(url: url, method: method)
        
        switch method {
        case .post, .put:
            // set content type headers
            setValue("application/json", forHTTPHeaderField: "Content-Type")
            setValue("application/json", forHTTPHeaderField: "Accept")
            
            // set body content
            let encoder = JSONEncoder()
            
            encoder.dateEncodingStrategy = .formatted({
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                formatter.calendar = Calendar(identifier: .iso8601)
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                formatter.locale = Locale(identifier: "en_US_POSIX")
                return formatter
                }())
            
            httpBody = try encoder.encode(body)
        default:
            break
        }
    }
}
