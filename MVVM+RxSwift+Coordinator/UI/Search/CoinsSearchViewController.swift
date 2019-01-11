//
//  CoinsSearchViewController.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira - VSV on 11/01/19.
//  Copyright © 2019 Vitor Silveira. All rights reserved.
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
class CoinsSearchViewController: UIViewController {
    // MARK: - Propriedades (Getters & Setters)
    
    // MARK: - Outlets
    
    // MARK: - Vars
    public weak var coordinator: AppCoordinator?
    
    // MARK: - Lets
    public let searchTextField = UITextField(borderStyle: .none, textAlignment: .natural)
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
        
        self.view.addSubview(self.searchTextField)
        self.searchTextField.snp.makeConstraints {
            $0.leading.equalTo(self.view.snp.leadingMargin)
            $0.top.equalTo(self.view.snp.topMargin)
            $0.trailing.equalTo(self.view.snp.trailingMargin)
            $0.height.equalTo(30)
        }
    }
    
    private func bindViewModel() {
        
    }
    
    private func setupBindings() {
        
    }
    
    // MARK: - Deinitializers
    
}

// MARK: - Extensions
