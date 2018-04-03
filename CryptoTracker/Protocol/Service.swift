//
//  Service.swift
//  CryptoTracker
//
//  Created by Niklas Sauer on 03.04.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Foundation

protocol Service {
    associatedtype PrimaryResource: Decodable
    associatedtype Client: APIClient
    var client: Client { get }
    init(credentials: APICredentialStore?)
}
