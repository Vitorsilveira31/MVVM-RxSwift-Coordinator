//
//  CoinAPIRouter.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira on 23/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import Foundation
import Moya

public enum Coins {
    case coins()
    case compare(fromSymbol: String, toSymbols: [String])
}

extension Coins: TargetType {
    public var baseURL: URL {
        switch self {
        case .coins:
            return URL(string: "https://api.coinmarketcap.com")!
        case .compare:
            return URL(string: "https://min-api.cryptocompare.com")!
        }
    }
    public var path: String {
        switch self {
        case .coins:
            return "/v1/ticker"
        case .compare:
            return "/data/price"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .coins, .compare:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .coins:
            return .requestPlain
        case .compare(let fromSymbol, let toSymbols):
            return .requestParameters(parameters: ["fsym" : fromSymbol, "tsyms" : toSymbols.joined(separator: ",")],
                                      encoding: URLEncoding.default)
        }
    }
    
    public var sampleData: Data {
        return "There is No smaple Data".data(using: String.Encoding.utf8)!
    }
    
    public var headers: [String: String]? {
        return nil
    }
}
