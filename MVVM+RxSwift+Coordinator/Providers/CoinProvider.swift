//
//  CoinProvider.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira on 23/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import Foundation

protocol CoinProvider {
    func fetchCoins(completion: @escaping (ServiceResult<[Coin]>) -> Void)
    func getComparison(from symbol: String, to symbols: [String], completion: @escaping (ServiceResult<[String: Double]>) -> Void )
}
