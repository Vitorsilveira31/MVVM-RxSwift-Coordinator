//
//  CoinsViewController.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira on 20/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

// MARK: - Imports
import UIKit
import RxSwift
import RxCocoa
import SnapKit

// MARK: - Typealias

// MARK: - Protocols

// MARK: - Constantes

// MARK: - Enums

// MARK: - Class/Objects
class CoinsViewController: UIViewController {
    // MARK: - Propriedades (Getters & Setters)
    
    // MARK: - Outlets
    
    // MARK: - Vars
    public weak var coordinator: AppCoordinator?
    
    private var coins: Observable<[Coin]>? {
        get { return self.viewModel?.coinList }
    }
    private var viewModel: CoinsViewModel?
    
    // MARK: - Lets
    public let searchTextField = DefaultTextField(placeholder: "Procurar..")
    public let coinsScrollView = UIScrollView()
    private let coinsView = UIView()
    private let coinsTableView = DynamicTableView(registeredCell: CoinTableViewCell.self,
                                                  rowHeight: 88.0,
                                                  allowsSelection: true)
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    
    // MARK: - Overrides
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
        self.view.addSubviewAttachingEdges(self.coinsScrollView,
                                           topConstraint: self.view.snp.topMargin,
                                           bottomConstraint: self.view.snp.bottomMargin)
        self.coinsScrollView.addSubview(self.coinsView)
        self.coinsView.snp.makeConstraints {
            $0.leading.equalTo(self.coinsScrollView.snp.leading)
            $0.top.equalTo(self.coinsScrollView.snp.top)
            $0.trailing.equalTo(self.coinsScrollView.snp.trailing)
            $0.bottom.equalTo(self.coinsScrollView.snp.bottom)
            $0.height.equalTo(self.coinsScrollView.snp.height).priority(.low)
            $0.width.equalTo(self.coinsScrollView.snp.width)
        }
        
        self.view.addSubview(self.searchTextField)
        self.searchTextField.snp.makeConstraints {
            $0.leading.equalTo(self.view.snp.leadingMargin).offset(10)
            $0.top.equalTo(self.view.snp.topMargin).offset(40)
            $0.trailing.equalTo(self.view.snp.trailingMargin).inset(10)
            $0.height.equalTo(35)
        }
        
        self.coinsTableView.isScrollEnabled = false
        let stackView = UIStackView(arrangedSubviews: [self.coinsTableView])
        self.coinsView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalTo(self.coinsView.snp.leading)
            $0.top.equalTo(self.coinsView.snp.top).offset(88)
            $0.trailing.equalTo(self.coinsView.snp.trailing)
            $0.bottom.equalTo(self.coinsView.snp.bottom)
        }
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
        
        self.coinsTableView.rx.itemSelected.map { $0 }.bind { indexPath in
            guard let coin = self.viewModel?.retrieveCoin(indexPath) else { return }
            let position = self.coinsTableView.convert(self.coinsTableView.rectForRow(at: indexPath), to: self.view)
            self.coordinator?.showDetails(coin: coin, position: position)
            self.coinsTableView.deselectRow(at: indexPath, animated: true)
            }.disposed(by: disposeBag)
        
        self.searchTextField.rx.controlEvent(.editingDidBegin).bind {
            self.searchTextField.endEditing(true)
            let vc = CoinsSearchViewController()
            vc.transitioningDelegate = self
            self.present(vc, animated: true)
        }.disposed(by: disposeBag)
    }
    
    // MARK: - Deinitializers
    
}

// MARK: - Extensions
extension CoinsViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = ToSearch()
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = FromSearch()
        return transition
    }
}
