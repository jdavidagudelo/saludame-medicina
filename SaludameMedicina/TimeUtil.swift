//
//  TimeUtil.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 12/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import Foundation
class TimeUtil{
    static let timeIntervalFormatter = NSDateFormatter()
    class func dateFromMinutesOfDay(minutesOfDay: Int) -> NSDate{
        let components = NSDateComponents()
        let calendar = NSCalendar.currentCalendar()
        components.hour = minutesOfDay/60
        components.minute = minutesOfDay%60
        components.second = 0
        let dateFromComponents = calendar.dateFromComponents(components)
        return dateFromComponents ?? NSDate()
    }
    class func textFromMinute(minutesOfDay: Int) -> String{
        let components = NSDateComponents()
        let calendar = NSCalendar.currentCalendar()
        components.hour = minutesOfDay/60
        components.minute = minutesOfDay%60
        components.second = 0
        let dateFromComponents = calendar.dateFromComponents(components)
        timeIntervalFormatter.dateFormat = "hh:mm a"
        let result = timeIntervalFormatter.stringFromDate(dateFromComponents!)
        return result
    }
    class func secondsToMinutes(secondsSince1970: NSNumber) -> Double{
        return Double(secondsSince1970)/60.0
    }
    class func todayStartMinutes() -> Double{
        let currentDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: currentDate)
        components.hour = 0
        components.minute = 0
        components.second = 0
        //let offset = calendar.timeZone.secondsFromGMT
        let offset = calendar.timeZone.secondsFromGMT
        return (calendar.dateFromComponents(components)?.timeIntervalSince1970 ?? 0.0 + Double(offset))/60.0
    }
    class func dayMinuteFromDate(date: NSDate) -> Double
    {
        let calendar = NSCalendar.currentCalendar()
        //let offset = calendar.timeZone.secondsFromGMT
        let components = calendar.components([.Hour, .Minute, .Second], fromDate: date)
        return Double(components.hour)*60.0 + Double(components.minute) + Double(components.second)/60.0
    }
}