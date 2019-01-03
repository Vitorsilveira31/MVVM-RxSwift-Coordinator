//
//  DateFormatter.swift
//  MVVM+Arch
//
//  Created by Vitor Silveira on 22/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import Foundation

enum AppDateFormat: String {
    case d = "d"
    case dd = "dd"
    case ddMM = "dd/MM"
    case ddMMMM = "dd MMMM"
    case dofMMMM = "d 'de' MMMM"
    case ddofMMM = "dd 'de' MMM"
    case ddofMMMM = "dd 'de' MMMM"
    case ddofMMMMEEEE = "dd 'de' MMMM, EEEE"
    case ddMMyyyy = "dd/MM/yyyy"
    case MMM = "MMM"
    case MMMM = "MMMM"
    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    case EEEE = "EEEE"
    case HHmm = "HH:mm"
    case HHhmm = "HH'h'mm"
    case HHmmss = "HH:mm:ss"
    case EEddMMyyyy = "EE, dd/MM/yyyy"
    case EEddofMMofyyyy = "EE, dd 'de' MMM 'de' yyyy"
    case yyyyMMdd = "yyyy-MM-dd"
}

extension DateFormatter {
    
    private static let kPTBRLocale = "pt_BR"
    
    static func appDateFormatter(withFormat format: AppDateFormat) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale(identifier: kPTBRLocale)
        return formatter
    }
}
