//
//  Date.swift
//  MVVM+Arch
//
//  Created by Vitor Silveira - VSV on 22/12/18.
//  Copyright © 2018 Vitor Silveira - VSV. All rights reserved.
//

import Foundation

enum AppDate: String {
    case day
    case week
    case month
    case year
}

extension Date {
    
    private static let daysInAWeek = 7
    
    func dayOfMonth() -> String? {
        return toString(format: .ddofMMMM)
    }
    
    func dayOfWeek() -> String? {
        return toString(format: .EEEE)
    }
    
    func toString(format: AppDateFormat) -> String {
        let dateFormat = DateFormatter.appDateFormatter(withFormat: format)
        return dateFormat.string(from: self)
    }
    
    func add(component: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self) ?? self
    }
    
    func isTheSameDay(date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    func isTheSameMonth(date: Date) -> Bool {
        let calendar = Calendar.current
        let fromDate = calendar.startOfDay(for: self)
        let toDate = calendar.startOfDay(for: date)
        
        return calendar.compare(fromDate, to: toDate, toGranularity: .month) == .orderedSame
    }
    
    func differenceBetweenDays(date: Date) -> Int {
        let calendar = Calendar.current
        let fromDate = calendar.startOfDay(for: self)
        let toDate = calendar.startOfDay(for: date)
        
        let components = calendar.dateComponents([.day], from: fromDate, to: toDate)
        return components.day ?? 0
    }
    
    func differenceInYears(date: Date) -> Int {
        let calendar = Calendar.current
        let fromDate = calendar.startOfDay(for: self)
        let toDate = calendar.startOfDay(for: date)
        
        let components = calendar.dateComponents([.day, .year], from: fromDate, to: toDate)
        return components.year ?? 0
    }
    
    func addMonths(_ months: Int) -> Date {
        return add(component: .month, value: months)
    }
    
    func addWeeks(_ weeks: Int) -> Date {
        return add(component: .weekday, value: weeks * Date.daysInAWeek)
    }
    
    func addDays(_ days: Int) -> Date {
        return add(component: .day, value: days)
    }
    
    func differenceBetweenMonths(date: Date) -> Int {
        let calendar = Calendar.current
        let fromDateYear = calendar.component(.year, from: self)
        let fromDateMonth = calendar.component(.month, from: self)
        let toDateYear = calendar.component(.year, from: date)
        let toDateMonth = calendar.component(.month, from: date)
        
        let diffMonth = (toDateYear - fromDateYear) * 12 + (toDateMonth - fromDateMonth)
        
        return diffMonth
    }
    
}
