//
//  Security.swift
//  MVVM+Arch
//
//  Created by Vitor Silveira on 22/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import Foundation
import CommonCrypto

struct Encryt {
    
    static func sha256(string: String) -> String? {
        guard let messageData = string.data(using: String.Encoding.utf8) else { return nil }
        var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_SHA256(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        let shaHex =  digestData.map { String(format: "%02hhx", $0) }.joined()
        
        return shaHex
    }
    
    static func sha1(string: String) -> String? {
        guard let messageData = string.data(using: String.Encoding.utf8) else { return nil }
        var digestData = Data(count: Int(CC_SHA1_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_SHA1(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        let shaHex =  digestData.map { String(format: "%02hhx", $0) }.joined()
        
        return shaHex
    }
}
