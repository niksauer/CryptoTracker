//
//  CryptoCompareService
//  CryptoTracker
//
//  Created by Niklas Sauer on 03.04.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Foundation

enum CryptoCompareAPIError: Error {
    case invalidData
    case invalidJSON
}

struct CryptoCompareService {

    // MARK: - Public Properties
    struct ExchangeRate {
        let date: Date
        let currencyPair: CurrencyPair
        let value: Double
    }
    
    // MARK: - Private Properties
    private let client: SimpleAPIClient
    
    // MARK: - Initialization
    init(credentials: APICredentialStore?) {
        self.client = SimpleAPIClient(baseURL: "https://min-api.cryptocompare.com/data", credentials: credentials)
    }
    
    // MARK: - Public Methods
    func getExchangeRate(for currencyPair: CurrencyPair, completion: @escaping (ExchangeRate?, Error?) -> Void) {
        let params = [
            "fsym": currencyPair.base.code,
            "tsyms": currencyPair.quote.code,
        ]
        
        client.makeGETRequest(to: "/price", params: params) { result in
            switch result {
            case .success(let data) where data != nil:
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                    
                    guard let jsonDictionary = jsonObject as? [AnyHashable: Any], let value = jsonDictionary[currencyPair.quote.code] as? Double else {
                        completion(nil, CryptoCompareAPIError.invalidJSON)
                        return
                    }
                    
                    let exchangeRate = ExchangeRate(date: Date(), currencyPair: currencyPair, value: value)
                    completion(exchangeRate, nil)
                } catch {
                    completion(nil, CryptoCompareAPIError.invalidData)
                }
            case .failure(let error):
                completion(nil, error)
            default:
                completion(nil, nil)
            }
        }
    }

}
