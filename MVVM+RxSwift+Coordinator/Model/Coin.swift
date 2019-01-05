//
//  Coin.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira on 22/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import Foundation

public struct Coin: Codable {
    
    let id : String
    let name : String
    let symbol : String
    let priceUsd: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case symbol = "symbol"
        case priceUsd = "price_usd"
    }
}
