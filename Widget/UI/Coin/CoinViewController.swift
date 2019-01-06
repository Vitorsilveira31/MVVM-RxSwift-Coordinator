//
//  CoinViewController.swift
//  Widget
//
//  Created by Vitor Silveira - VSV on 05/01/19.
//  Copyright © 2019 Vitor Silveira. All rights reserved.
//

import UIKit
import NotificationCenter
import RxSwift
import RxCocoa

class CoinViewController: UIViewController, NCWidgetProviding {
    
    private let disposeBag = DisposeBag()
    private var viewModel: CoinViewModel? = CoinViewModel()
    private var coin: Observable<Coin?>? {
        get { return self.viewModel?.coinItem }
    }
    
    private var coinImageView = UIImageView(contentMode: .scaleAspectFill, clipsToBounds: true) {
        didSet {
            self.coinImageView.circleCorner = true
        }
    }
    private var coinNameLabel = UILabel(withSize: 12.0, withColor: .darkGrey, withText: "Nome:", withLines: 1)
    private var coinSymbolLabel = UILabel(withSize: 12.0, withColor: .darkGrey, withText: "Símbolo:", withLines: 1)
    private var coinPriceLabel = UILabel(withSize: 12.0, withColor: .darkGrey, withText: "Preço USD:", withLines: 1)
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    private let dimmView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let emptyView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        bindViewModel()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel?.fetchData()
    }
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    private func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        viewModel?.state.asObservable().bind(onNext: { state in
            switch state {
            case .loading:
                completionHandler(NCUpdateResult.noData)
            case .loaded:
                completionHandler(NCUpdateResult.newData)
            case .empty:
                completionHandler(NCUpdateResult.noData)
            }
        }).disposed(by: disposeBag)
    }
    
    private func configureViews() {
        self.view.addSubview(self.coinImageView)
        self.coinImageView.snp.makeConstraints {
            $0.height.equalTo(75)
            $0.width.equalTo(75)
            $0.centerY.equalTo(self.view.snp.centerY)
            $0.leading.equalTo(self.view.snp.leadingMargin)
        }
        
        let stackView = UIStackView(arrangedSubviews: [self.coinNameLabel, self.coinSymbolLabel, self.coinPriceLabel], axis: .vertical, spacing: 3, alignment: .fill, distribution: .equalCentering)
        
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalTo(self.coinImageView.snp.trailingMargin).offset(20)
            $0.top.equalTo(self.coinImageView.snp.topMargin)
            $0.bottom.equalTo(self.coinImageView.snp.bottomMargin)
        }
    }
    
    private func bindViewModel() {
        viewModel?.state.bind(onNext: { state in
            switch state {
            case .loading:
                debugPrint("loading")
                self.showLoading()
            case .loaded:
                debugPrint("loaded")
                self.removeEmptyView()
                self.dismissLoading()
            case .empty:
                debugPrint("empty")
                self.dismissLoading()
                self.showEmptyView()
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        coin?.bind(onNext: { [unowned self] coin in
            guard let coin = coin else { return }
            DownloaderImage(url: "https://res.cloudinary.com/dxi90ksom/image/upload/\(coin.symbol).png",
                imageView: self.coinImageView).commomInit()
            self.coinNameLabel.text = "Nome: \(coin.name)"
            self.coinSymbolLabel.text = "Símbolo: \(coin.symbol)"
            self.coinPriceLabel.text = "Preço USD: \(Double(coin.priceUsd)?.formatUsingAbbrevation ?? "")"
        }).disposed(by: disposeBag)
        
    }
    
    private func showLoading() {
        self.view.addSubviewAttachingEdges(dimmView)
        self.view.addSubviewAttachingEdges(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    private func dismissLoading() {
        self.dimmView.removeFromSuperview()
        self.activityIndicator.removeFromSuperview()
    }
    
    private func showEmptyView() {
        emptyView.backgroundColor = .white
        self.view.addSubviewAttachingEdges(emptyView)
        let messageLabel = UILabel(withColor: .black, withText: "Para exibir dados no widget, selecione algum no aplicativo!", withTextAlignment: .center, withLines: 2)
        emptyView.addSubviewAttachingEdges(messageLabel)
    }
    
    private func removeEmptyView() {
        self.emptyView.removeFromSuperview()
    }
    
}
