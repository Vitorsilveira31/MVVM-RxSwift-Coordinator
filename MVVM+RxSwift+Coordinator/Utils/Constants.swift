//
//  Constants.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira - VSV on 06/01/19.
//  Copyright © 2019 Vitor Silveira. All rights reserved.
//

import Foundation

struct K {
    struct CoinAPIServer {
        static let baseURL = "https://api.coinmarketcap.com"
    }
    
    struct CoinComparisonAPIServer {
        static let baseURL = "https://min-api.cryptocompare.com"
    }
    
    struct Defaults {
        static let PlaceholderImage = "placeholder"
        static let BitcoinImage = "bitcoin"
        static func CoinImage(symbol: String) -> String {
            return "https://res.cloudinary.com/dxi90ksom/image/upload/\(symbol).png"
        }
        static let MagnifyingGlassImage = "ic_glass"
    }
}
