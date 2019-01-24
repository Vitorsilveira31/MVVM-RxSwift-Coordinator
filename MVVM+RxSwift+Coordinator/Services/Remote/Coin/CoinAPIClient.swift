//
//  CoinAPIClient.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira on 23/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import Foundation

class CoinAPIClient: BaseAPIClient, CoinProvider {
    
    public static let shared = CoinAPIClient()
    
    func fetchCoins(completion: @escaping (ServiceResult<[Coin]>) -> Void) {
        requestWithCodableResponse(Coins.coins(), completion: completion)
    }
    
    func getComparison(from symbol: String, to symbols: [String], completion: @escaping (ServiceResult<[String : Double]>) -> Void) {
        requestWithoutCodableResponse(Coins.compare(fromSymbol: symbol, toSymbols: symbols), completion: completion)
    }
    
}
