//
//  DynamicTableView.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira - VSV on 11/01/19.
//  Copyright © 2019 Vitor Silveira. All rights reserved.
//

import UIKit

class DynamicTableView: UITableView {
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
}
