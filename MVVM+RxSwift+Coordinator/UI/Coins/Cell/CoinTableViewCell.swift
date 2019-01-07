//
//  CoinTableViewCell.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira on 22/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import UIKit
import SnapKit

class CoinTableViewCell: UITableViewCell {
    
    public var coin: Coin? = nil {
        didSet {
            guard let coin = coin else { return }
            self.nameCoinLabel.text = "\(coin.name) (\(coin.symbol))"
            DownloaderImage(url: K.Defaults.CoinImage(symbol: coin.symbol),
                            imageView: self.coinImageView).commomInit()
        }
    }
    
    private var coinImageView = UIImageView(contentMode: .scaleAspectFill, clipsToBounds: true)
    
    private var nameCoinLabel = UILabel(withColor: .darkGrey)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.accessoryType = .disclosureIndicator
        
        self.contentView.addSubview(self.coinImageView)
        self.coinImageView.snp.makeConstraints {
            $0.width.equalTo(72)
            $0.height.equalTo(72)
            $0.centerY.equalTo(self.contentView.snp.centerY)
            $0.leading.equalTo(self.contentView.snp.leadingMargin)
        }
        
        self.contentView.addSubview(self.nameCoinLabel)
        self.nameCoinLabel.snp.makeConstraints {
            $0.leading.equalTo(self.coinImageView.snp.trailing).offset(10)
            $0.top.equalTo(self.contentView.snp.topMargin)
            $0.trailing.equalTo(self.contentView.snp.trailingMargin)
            $0.bottom.equalTo(self.contentView.snp.bottomMargin)
        }
        
        self.coinImageView.circleCorner = true
    }
}
