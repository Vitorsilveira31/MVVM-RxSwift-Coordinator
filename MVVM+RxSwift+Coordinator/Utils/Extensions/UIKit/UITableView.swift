//
//  UITableView.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira on 22/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import UIKit

extension UITableView {
    convenience init<T: UITableViewCell>(registeredCell cell: T.Type,
                                         separatorStyle: UITableViewCell.SeparatorStyle = .none,
                                         rowHeight: CGFloat,
                                         allowsMultipleSelection: Bool = false,
                                         allowsSelection: Bool = true) {
        self.init()
        self.separatorStyle = separatorStyle
        self.allowsSelection = allowsSelection
        self.allowsMultipleSelection = allowsMultipleSelection
        self.register(T.self)
        self.rowHeight = rowHeight
    }
    
    func register<T: UITableViewCell>(_: T.Type, reuseIdentifier: String? = nil) {
        self.register(T.self, forCellReuseIdentifier: reuseIdentifier ?? String(describing: T.self))
    }
    
}
