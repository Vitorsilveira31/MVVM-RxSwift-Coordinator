//
//  Encodable.swift
//  MVVM+Arch
//
//  Created by Vitor Silveira - VSV on 22/12/18.
//  Copyright © 2018 Vitor Silveira - VSV. All rights reserved.
//

import Foundation

extension Encodable {
    
    var encodedDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    var encodedData: Data? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return data
    }
}
