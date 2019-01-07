//
//  CoinDetailsViewController.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira on 23/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class CoinDetailsViewController: UIViewController {
    
    // MARK: - Vars
    public weak var coordinator: AppCoordinator?
    
    public var coin: Coin
    
    private var coinsDetailList: Observable<[String : Double]>? {
        get { return self.viewModel?.coinsDetailList }
    }
    private var viewModel: CoinDetailsViewModel?
    
    // MARK: - Lets
    private let amountTextField = UITextField(borderStyle: .roundedRect, textAlignment: .center)
    private let amountStepper = UIStepper(stepValue: 1.0, minimumValue: 1.0, maximumValue: 5.0)
    private let valuesTableView = UITableView(registeredCell: CoinDetailTableViewCell.self,
                                              rowHeight: 72,
                                              allowsSelection: false)
    private let dismissButton = UIButton(type: .system, font: .bold, withSize: 22.0, withTitle: "X", withTitleColor: nil)
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(coin: Coin) {
        self.coin = coin
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        self.view.addSubview(self.dismissButton)
        
        self.dismissButton.snp.makeConstraints {
            $0.top.equalTo(self.view.snp.topMargin)
            $0.leading.equalTo(self.view.snp.leadingMargin)
        }
        
        let coinImageView = UIImageView(contentMode: .scaleAspectFit)
        
        self.view.addSubview(coinImageView)
        coinImageView.snp.makeConstraints {
            $0.top.equalTo(self.dismissButton.snp.bottomMargin).offset(20)
            $0.centerX.equalTo(self.view.snp.centerX)
            $0.width.equalTo(144)
            $0.height.equalTo(144)
        }
        DownloaderImage(url: K.Defaults.CoinImage(symbol: coin.symbol),
                        imageView: coinImageView).commomInit()
        
        let coinNameLabel = UILabel(withText: "\(coin.name) (\(coin.symbol))")
        self.view.addSubview(coinNameLabel)
        coinNameLabel.snp.makeConstraints {
            $0.top.equalTo(coinImageView.snp.bottom).offset(13)
            $0.centerX.equalTo(self.view.snp.centerX)
        }
        
        let stack = UIStackView(axis: .horizontal, spacing: 8.0, alignment: .center, distribution: .fillEqually)
        
        let amountLabel = UILabel(withText: "Quantidade:")
        
        stack.addArrangedSubview(amountLabel)
        
        stack.addArrangedSubview(amountTextField)
        
        stack.addArrangedSubview(amountStepper)
        
        self.view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.leading.equalTo(self.view.snp.leading).offset(18)
            $0.top.equalTo(coinNameLabel.snp.bottom).offset(13)
            $0.trailing.equalTo(self.view.snp.trailing).inset(18)
        }
        
        self.view.addSubview(valuesTableView)
        
        valuesTableView.snp.makeConstraints {
            $0.leading.equalTo(self.view.snp.leading).offset(18)
            $0.top.equalTo(stack.snp.bottom).offset(13)
            $0.trailing.equalTo(self.view.snp.trailing).inset(18)
            $0.bottom.equalTo(self.view.snp.bottomMargin)
        }
    }
    
    private func bindViewModel() {
        viewModel = CoinDetailsViewModel(coin: coin,
                                         fieldDriver: amountTextField.rx.value.asDriver(),
                                         stepperDriver: amountStepper.rx.value.asDriver())
        
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
        
        viewModel?.reference.bind(onNext: { [weak self] value in
            self?.amountStepper.value = value > 5 ? 5 : value
            self?.amountTextField.text = String(format: "%.0f", value) 
        }).disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        dismissButton.rx.tap.bind {
            self.coordinator?.clearCoin()
            }.disposed(by: disposeBag)
        
        coinsDetailList?.bind(to: self.valuesTableView.rx.items(cellIdentifier: String(describing: CoinDetailTableViewCell.self), cellType: CoinDetailTableViewCell.self)) { row, element, cell in
            cell.coin = (element.key, element.value)
            }.disposed(by: disposeBag)
        
        amountTextField.rx.text.orEmpty
            .map{ String($0.prefix(15)) }
            .bind(to: amountTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Extensions
