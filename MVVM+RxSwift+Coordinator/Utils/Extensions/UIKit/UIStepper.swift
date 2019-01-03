//
//  UIStepper.swift
//  MVVM+Arch
//
//  Created by Vitor Silveira on 28/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import UIKit

extension UIStepper {
    convenience init(stepValue: Double, minimumValue: Double, maximumValue: Double) {
        self.init()
        self.stepValue = stepValue
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
    }
}
