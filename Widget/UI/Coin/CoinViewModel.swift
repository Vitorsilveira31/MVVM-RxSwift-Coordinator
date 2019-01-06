//
//  CoinViewModel.swift
//  Widget
//
//  Created by Vitor Silveira - VSV on 05/01/19.
//  Copyright © 2019 Vitor Silveira. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public enum CoinViewState {
    case loading
    case loaded
    case empty
}

class CoinViewModel {
    
    // MARK: - Vars
    public var coinItem: Observable<Coin?> {
        return coin.asObservable()
    }
    public var state: Observable<CoinViewState> {
        return viewState.asObservable()
    }
    
    private var coin: BehaviorRelay<Coin?> = BehaviorRelay(value: nil)
    private var viewState: BehaviorRelay<CoinViewState>
    
    // MARK: - Lets
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init() {
        self.viewState = BehaviorRelay<CoinViewState>(value: .loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.viewState.accept(.empty)
        }
    }
    
    // MARK: - Public Methods
    public func fetchData() {
        self.viewState.accept(.loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.coin.accept(PreferencesService.shared.retrieve(key: Keys.Coin))
            if let _ = self?.coin.value {
                self?.viewState.accept(.loaded)
            } else {
                self?.viewState.accept(.empty)
            }
        }
    }
    
    // MARK: - Private Methods
    
}

// MARK: - Extensions
