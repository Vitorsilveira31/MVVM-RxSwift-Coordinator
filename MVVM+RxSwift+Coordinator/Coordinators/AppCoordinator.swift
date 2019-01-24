//
//  AppCoordinator.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira on 28/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    var window: UIWindow? { get set }
    func start()
}

class AppCoordinator: NSObject, Coordinator {
    
    private let transition = Scale()
    private var oppenedCoin: Bool {
        return PreferencesService.shared.has(key: Keys.Coin)
    }
    private var coin: Coin? {
        return PreferencesService.shared.retrieve(key: Keys.Coin)
    }
    private var position: CGRect?
    private let rootVC = CoinsViewController()
    internal var window: UIWindow?
    
    init(window: UIWindow?) {
        super.init()
        self.rootVC.coordinator = self
        self.window = window
        self.window?.rootViewController = self.rootVC
        self.window?.makeKeyAndVisible()
    }
    
    deinit {
        print("deallocing \(self)")
    }
    
    public func start() {
        if self.oppenedCoin, let coin = coin {
            showDetails(coin: coin, position: CGRect(x: 0, y: 0, width: rootVC.view.width, height: 50.0))
        }
    }
    
    public func showDetails(coin: Coin, position: CGRect) {
        PreferencesService.shared.store(preferences: Keys.Coin, value: coin)
        self.position = position
        let vc = CoinDetailsViewController(coin: coin)
        vc.coordinator = self
        vc.transitioningDelegate = self
        rootVC.present(vc, animated: true)
    }
    
    public func clearCoin() {
        self.rootVC.dismiss(animated: true) {
            PreferencesService.shared.clearUserDefaults()
        }
    }
    
}

extension AppCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = self.position ?? .zero
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
