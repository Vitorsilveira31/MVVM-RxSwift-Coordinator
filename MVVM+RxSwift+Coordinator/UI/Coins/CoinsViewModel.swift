//
//  CoinsViewModel.swift
//  MVVM+Arch
//
//  Created by Vitor Silveira on 20/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public enum CoinsViewState {
    case loading
    case loaded
    case empty
    case error(title: String, message: String)
}

class CoinsViewModel {
    
    // MARK: - Vars
    public var coinList: Observable<[Coin]> {
        return coins.asObservable()
    }
    public var state: Observable<CoinsViewState> {
        return viewState.asObservable()
    }
    
    private var coins: BehaviorRelay<[Coin]> = BehaviorRelay(value: [])
    private var viewState: BehaviorRelay<CoinsViewState>
    
    // MARK: - Lets
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init() {
        self.viewState = BehaviorRelay<CoinsViewState>(value: .loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewState.accept(.empty)
        }
    }
    
    // MARK: - Public Methods
    public func fetchData() {
        self.viewState.accept(.loading)
        self.coins.removeAll()
        CoinAPIClient.shared.fetchCoins { result in
            
            guard result.isSuccess, let item = result.item else {
                self.viewState.accept(.error(title: result.error.title, message: result.error.message))
                return
            }
            
            if item.isEmpty {
                self.viewState.accept(.empty)
                return
            }
            
            self.coins.append(contentsOf: item)
            self.viewState.accept(.loaded)
        }
    }
    
    public func retrieveCoin(_ indexPath: IndexPath) -> Coin {
        return self.coins.value[indexPath.row]
    }
    
    // MARK: - Private Methods
    
}

// MARK: - Extensions
