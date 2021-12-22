//
//  DateExtension.swift
//  FMS SPS 2017
//
//  Created by Elluminati iTunesConnect on 18/11/17.
//  Copyright © 2017 Harshil Kotecha. All rights reserved.
//

import Foundation

extension Date {
    
    func toString(withFormat format: String,timeZone:String = "") -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if timeZone != "" {
            formatter.timeZone = TimeZone.init(abbreviation: timeZone)
        }
        let myString = formatter.string(from: self)
        return  myString
    }
    func isSameDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedSame
    }
    
    func isBeforeDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedAscending
    }
    
    func isAfterDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedDescending
    }
    func dayNumberOfWeek() -> Int
    {
            return (Calendar.current.dateComponents([.weekday], from: self).weekday ?? 1) - 1
    }
    var millisecondsSince1970:Double {
        return Double((self.timeIntervalSince1970 * 1000.0).rounded())
    }

}
