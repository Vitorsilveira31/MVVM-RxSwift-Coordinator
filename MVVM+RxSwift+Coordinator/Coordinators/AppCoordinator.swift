//
//  AppCoordinator.swift
//  MVVM+Arch
//
//  Created by Vitor Silveira - VSV on 28/12/18.
//  Copyright © 2018 Vitor Silveira - VSV. All rights reserved.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

class AppCoordinator: Coordinator {
    
    private var oppenedCoin: Bool {
        return PreferencesService.shared.has(key: Keys.Coin)
    }
    private var coin: Coin? {
        return PreferencesService.shared.retrieve(key: Keys.Coin)
    }
    internal var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        print("deallocing \(self)")
    }
    
    public func start() {
        showCoins()
        if self.oppenedCoin, let coin = coin {
            showDetails(coin: coin)
        }
    }
    
    public func showCoins() {
        let vc = CoinsViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func showDetails(coin: Coin) {
        PreferencesService.shared.store(preferences: Keys.Coin, value: coin)
        let vc = CoinDetailsViewController(coin: coin)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func clearCoin() {
        PreferencesService.shared.clearUserDefaults()
    }
    
}
