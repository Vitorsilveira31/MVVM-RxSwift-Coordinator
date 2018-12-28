//
//  String.swift
//  MVVM+Arch
//
//  Created by Vitor Silveira - VSV on 22/12/18.
//  Copyright © 2018 Vitor Silveira - VSV. All rights reserved.
//

import Foundation

extension String {
    private static let emailSpecialCharacters = "._-"
    
    func toDate(format: AppDateFormat) -> Date? {
        let dateFormat = DateFormatter.appDateFormatter(withFormat: format)
        return dateFormat.date(from: self)
    }
    
    var isValidCPF: Bool {
        let numbers = self.compactMap({Int(String($0))})
        guard numbers.count == 11 && Set(numbers).count != 1 else { return false }
        let soma1 = 11 - ( numbers[0] * 10 +
            numbers[1] * 9 +
            numbers[2] * 8 +
            numbers[3] * 7 +
            numbers[4] * 6 +
            numbers[5] * 5 +
            numbers[6] * 4 +
            numbers[7] * 3 +
            numbers[8] * 2 ) % 11
        let dv1 = soma1 > 9 ? 0 : soma1
        let soma2 = 11 - ( numbers[0] * 11 +
            numbers[1] * 10 +
            numbers[2] * 9 +
            numbers[3] * 8 +
            numbers[4] * 7 +
            numbers[5] * 6 +
            numbers[6] * 5 +
            numbers[7] * 4 +
            numbers[8] * 3 +
            numbers[9] * 2 ) % 11
        let dv2 = soma2 > 9 ? 0 : soma2
        return dv1 == numbers[9] && dv2 == numbers[10]
    }
    
    var isValidCNPJ: Bool {
        let numbers = self.compactMap({Int(String($0))})
        guard numbers.count == 14 && Set(numbers).count != 1 else { return false }
        let soma1 = 11 - ( numbers[11] * 2 +
            numbers[10] * 3 +
            numbers[9] * 4 +
            numbers[8] * 5 +
            numbers[7] * 6 +
            numbers[6] * 7 +
            numbers[5] * 8 +
            numbers[4] * 9 +
            numbers[3] * 2 +
            numbers[2] * 3 +
            numbers[1] * 4 +
            numbers[0] * 5 ) % 11
        let dv1 = soma1 > 9 ? 0 : soma1
        let soma2 = 11 - ( numbers[12] * 2 +
            numbers[11] * 3 +
            numbers[10] * 4 +
            numbers[9] * 5 +
            numbers[8] * 6 +
            numbers[7] * 7 +
            numbers[6] * 8 +
            numbers[5] * 9 +
            numbers[4] * 2 +
            numbers[3] * 3 +
            numbers[2] * 4 +
            numbers[1] * 5 +
            numbers[0] * 6 ) % 11
        let dv2 = soma2 > 9 ? 0 : soma2
        return dv1 == numbers[12] && dv2 == numbers[13]
    }
    
    var isValidEmail: Bool {
        let emailRegEx: String = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
            "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidCPFLength: Bool {
        return self.count == 14
    }
    
    var isValidCNPJLength: Bool {
        return self.count == 18
    }
    
    func camelCase() -> String {
        return self.components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .map { $0.capitalized }
            .joined()
    }
    
    func camelCaseWithPontuation() -> String {
        return self.components(separatedBy: CharacterSet.whitespaces)
            .filter { !$0.isEmpty }
            .map { $0.capitalized }
            .joined()
    }
    
    mutating func camelCased() {
        self = self.camelCase()
    }
    
    var llamaCase: String {
        var result = self.camelCase()
        if let firstLetter = result.first?.stringValue {
            result = firstLetter.lowercased() + result
        }
        
        return result
    }
    
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    var removeAccentsAndSpecialCharactersToCamelCase: String {
        return self.folding(options: .diacriticInsensitive, locale: .current).camelCase()
    }
    
    var removeAccentsAndSpecialCharacters: String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
    }
    
    var addBrackets: String {
        return "[\(self)]"
    }
    
    var isAlphanumeric: Bool {
        return self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil && self != ""
    }
    
    func padLeft(totalWidth: Int, with: String) -> String {
        let toPad = totalWidth - self.count
        if toPad < 1 { return self }
        return "".padding(toLength: toPad, withPad: with, startingAt: 0) + self
    }
    
    var removeZeroOccurrencesInitial: String {
        return self.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
    }
    
    var accountFormat: String {
        var trimmedString = self.removeZeroOccurrencesInitial
        let digit = trimmedString.removeLast()
        return "\(trimmedString)-\(digit)"
    }
    
    var cardNumberFormat: String {
        var newString = self
        if newString.count == 16 {
            newString.insert(" ", at: newString.index(newString.startIndex, offsetBy: 12))
            newString.insert(" ", at: newString.index(newString.startIndex, offsetBy: 8))
            newString.insert(" ", at: newString.index(newString.startIndex, offsetBy: 4))
        }
        return newString
    }
    
    var cpfCnpjFormat: String {
        var newString = self
        if newString.count == 14 {
            newString.insert("-", at: newString.index(newString.startIndex, offsetBy: 12))
            newString.insert("/", at: newString.index(newString.startIndex, offsetBy: 8))
            newString.insert(".", at: newString.index(newString.startIndex, offsetBy: 5))
            newString.insert(".", at: newString.index(newString.startIndex, offsetBy: 2))
        } else if newString.count == 11 {
            newString.insert("-", at: newString.index(newString.startIndex, offsetBy: 9))
            newString.insert(".", at: newString.index(newString.startIndex, offsetBy: 6))
            newString.insert(".", at: newString.index(newString.startIndex, offsetBy: 3))
        }
        return newString
    }
    
    var trim: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}
