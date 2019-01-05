//
//  CoinDetailTableViewCell.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira on 24/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import UIKit

class CoinDetailTableViewCell: UITableViewCell {

    public var coin: (String, Double)? = nil {
        didSet {
            guard let coin = coin else { return }
            nameCoinLabel.text = coin.0
            valueCoinLabel.text = coin.1.formatUsingAbbrevation
        }
    }
    
    private var nameCoinLabel = UILabel(withColor: .darkGrey)
    
    private var valueCoinLabel = UILabel(withColor: .darkGrey)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.addSubview(self.nameCoinLabel)
        self.nameCoinLabel.snp.makeConstraints {
            $0.leading.equalTo(self.contentView.snp.leading)
            $0.centerY.equalTo(self.contentView.snp.centerY)
        }
        
        self.contentView.addSubview(self.valueCoinLabel)
        self.valueCoinLabel.snp.makeConstraints {
            $0.trailing.equalTo(self.contentView.snp.trailing)
            $0.centerY.equalTo(self.contentView.snp.centerY)
            $0.leading.greaterThanOrEqualTo(self.nameCoinLabel.snp.trailing).offset(10)
        }
    }
    
}
