//
//  Data.swift
//  MVVM+Arch
//
//  Created by Vitor Silveira - VSV on 22/12/18.
//  Copyright © 2018 Vitor Silveira - VSV. All rights reserved.
//

import Foundation

extension Data {
    
    func decode<T>() throws -> T where T: Decodable {
        return try JSONDecoder().decode(T.self, from: self)
    }
    
    func jsonObject(options: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: options)
    }
}
