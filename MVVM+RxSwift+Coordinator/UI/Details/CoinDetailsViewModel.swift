//
//  CoinDetailsViewModel.swift
//  MVVM+Arch
//
//  Created by Vitor Silveira on 23/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public enum CoinDetailsViewState {
    case loading
    case loaded
    case empty
    case error(title: String, message: String)
}

class CoinDetailsViewModel {
    
    // MARK: - Vars
    public var coin: Coin
    public var coinsDetailList: Observable<[String : Double]> {
        return coinsDetail.asObservable()
    }
    public var state: Observable<CoinDetailsViewState> {
        return viewState.asObservable()
    }
    public var reference: Observable<Double> {
        return referenceValue.asObservable()
    }
    
    private var originalCoinsDetail = [String : Double]()
    private var coinsDetail: BehaviorRelay<[String : Double]> = BehaviorRelay(value: [:])
    private var viewState: BehaviorRelay<CoinDetailsViewState>
    private var referenceValue: BehaviorRelay<Double> = BehaviorRelay(value: 1.0)
    
    // MARK: - Lets
    private let disposeBag = DisposeBag()
    
    init(coin: Coin, fieldDriver: SharedSequence<DriverSharingStrategy, String?>, stepperDriver: SharedSequence<DriverSharingStrategy, Double>) {
        self.viewState = BehaviorRelay<CoinDetailsViewState>(value: .loading)
        self.coin = coin
        fieldDriver.asObservable().bind {
            guard let value = $0, let doubleValue = Double(value) else {
                self.referenceValue.accept(1)
                return
            }
            self.referenceValue.accept(doubleValue)
            }.disposed(by: disposeBag)
        
        stepperDriver.asObservable().bind {
            self.referenceValue.accept($0)
            }.disposed(by: disposeBag)
        
        reference.bind(onNext: { value in
            var newValues = [String : Double]()
            for i in self.originalCoinsDetail {
                newValues[i.key] = i.value * self.referenceValue.value
            }
            self.coinsDetail.accept(newValues)
        }).disposed(by: disposeBag)
        
        self.fetchData()
    }
    
    // MARK: - Public Methods
    public func fetchData() {
        CoinAPIClient.shared.getComparison(from: coin.symbol, to: ["BRL", "USD", "EUR"], completion: { result in
            guard result.isSuccess, let item = result.item else {
                self.viewState.accept(.error(title: result.error.title, message: result.error.message))
                return
            }
            
            if item.isEmpty {
                self.viewState.accept(.empty)
                return
            }
            
            self.originalCoinsDetail = item
            self.coinsDetail.accept(item)
            self.viewState.accept(.loaded)
        })
    }
    
    // MARK: - Private Methods
}

// MARK: - Extensions
