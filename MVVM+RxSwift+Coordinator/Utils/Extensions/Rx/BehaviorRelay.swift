//
//  BehaviorRelay.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira on 23/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import Foundation
import RxCocoa

public extension BehaviorRelay where Element: RangeReplaceableCollection {
    
    public func append(_ newElement: Element.Element) {
        var newValue = value
        newValue.append(newElement)
        accept(newValue)
    }
    
    public func append(contentsOf newElements: Element) {
        var newValue = value
        newValue.append(contentsOf: newElements)
        accept(newValue)
    }
    
    public func insert(_ newElement: Element.Element, at index: Element.Index) {
        var newValue = value
        newValue.insert(newElement, at: index)
        accept(newValue)
    }
    
    public func insert(contentsOf newSubelements: Element, at index: Element.Index) {
        var newValue = value
        newValue.insert(contentsOf: newSubelements, at: index)
        accept(newValue)
    }
    
    public func remove(at index: Element.Index) {
        var newValue = value
        newValue.remove(at: index)
        accept(newValue)
    }
    
    public func removeAll() {
        var newValue = value
        newValue.removeAll()
        accept(newValue)
    }
}
