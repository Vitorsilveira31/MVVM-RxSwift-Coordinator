//
//  CoinsViewController.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira on 20/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class CoinsViewController: UIViewController {
    
    // MARK: - Vars
    public weak var coordinator: AppCoordinator?

    private var coins: Observable<[Coin]>? {
        get { return self.viewModel?.coinList }
    }
    private var viewModel: CoinsViewModel?
    
    // MARK: - Lets
    private let coinsTableView = UITableView(registeredCell: CoinTableViewCell.self,
                                             rowHeight: 88.0,
                                             allowsSelection: true)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        bindViewModel()
        setupBindings()
    }
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    private func configureViews() {
        self.view.backgroundColor = .white
        
        self.view.addSubviewAttachingEdges(self.coinsTableView,
                                           topConstraint: self.view.snp.topMargin,
                                           bottomConstraint: self.view.snp.bottomMargin)
    }
    
    private func bindViewModel() {
        self.viewModel = CoinsViewModel()
        
        viewModel?.state.bind(onNext: { state in
            switch state {
            case .loading:
                debugPrint("loading")
                self.showLoading()
            case .loaded:
                debugPrint("loaded")
                self.dismissLoading()
            case .empty:
                debugPrint("empty")
                self.dismissLoading()
                self.showEmptyView(image: UIImage(named: K.Defaults.BitcoinImage), title: "Sem Moedas", message: "O banco está vazio.", titleButton: "Buscar em outro banco", disposeBag: self.disposeBag) {
                    self.viewModel?.fetchData()
                }
            case .error(let title, let message):
                debugPrint("error")
                self.dismissLoading()
                self.showEmptyView(image: UIImage(named: K.Defaults.BitcoinImage), title: title, message: message, disposeBag: self.disposeBag) {
                    self.viewModel?.fetchData()
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        self.coins?.bind(to: self.coinsTableView.rx.items(cellIdentifier: String(describing: CoinTableViewCell.self), cellType: CoinTableViewCell.self)) { row, element, cell in
            cell.coin = element
            }.disposed(by: disposeBag)
        
        self.coinsTableView.rx.itemSelected.map { $0 }.bind {
            guard let coin = self.viewModel?.retrieveCoin($0) else { return }
            let position = self.coinsTableView.convert(self.coinsTableView.rectForRow(at: $0), to: self.coinsTableView.superview)
            self.coordinator?.showDetails(coin: coin, position: position)
            self.coinsTableView.deselectRow(at: $0, animated: true)
            }.disposed(by: disposeBag)
    }
    
}

// MARK: - Extensions
