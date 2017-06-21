//
//  NSDate.swift
//  EarlySalary
//
//  Created by Geekyworks Pvt. Ltd. on 2/16/16.
//  Copyright © 2016 Geekyworks Pvt. Ltd. All rights reserved.
//

import UIKit

extension Date {
    // Date from string with format
    init(dateString:String, format:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = format
        dateStringFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let d = dateStringFormatter.date(from: dateString) {
            self.init(timeInterval:0, since:d)
        }
        else {
            self.init()
        }
    }
    
    struct Formatter {
        static let iso8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.ISO8601)! as Calendar
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
            formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            return formatter
        }()
    }
    
    // Additions
    func addDays(_ days:Int) -> Date? {
        var dayComponent:DateComponents = DateComponents()
        dayComponent.day = days
        let calendar:Calendar = Calendar.current
        return (calendar as NSCalendar).date(byAdding: dayComponent, to: self, options: NSCalendar.Options.matchStrictly)
    }
    
    func addHours(_ hoursToAdd: Int) -> Date {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
    
    // Conversion
    func getStringWithFormat(_ format:String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    // Comparison
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func daysDifferenceTo(_ toDate: Date) -> Int {
        let cal = Calendar.current
        let unit: NSCalendar.Unit = NSCalendar.Unit.day
        
        return (cal as NSCalendar).components(unit, from: self, to: toDate, options: NSCalendar.Options.matchStrictly).day!
    }
}

