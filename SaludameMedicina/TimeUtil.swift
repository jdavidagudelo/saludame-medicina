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
    class func dateFromMinutesOfDay(minutesOfDay: Int, date: NSDate) -> NSDate{
        let components = NSDateComponents()
        let calendar = NSCalendar.currentCalendar()
        let componentsDate = calendar.components([.Day, .Month, .Year], fromDate: date)
        components.day = componentsDate.day
        components.month = componentsDate.month
        components.year = componentsDate.year
        components.hour = minutesOfDay/60
        components.minute = minutesOfDay%60
        components.second = 0
        let dateFromComponents = calendar.dateFromComponents(components)
        return dateFromComponents ?? NSDate()
    }
    class func textFromMinute(minutesOfDay: Int) -> String{
        let components = NSDateComponents()
        let calendar = NSCalendar.currentCalendar()
        components.hour = minutesOfDay/(60)
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
    class func dateStartMinutes(date:NSDate) -> Double{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: date)
        components.hour = 0
        components.minute = 0
        components.second = 0
        //let offset = calendar.timeZone.secondsFromGMT
        return (calendar.dateFromComponents(components)?.timeIntervalSince1970 ?? 0.0)/60.0
    }
    class func getTomorrowStart() -> NSDate{
        var date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: date)
        components.hour = 0
        components.minute = 0
        components.second = 0
        let yesterday = NSDateComponents()
        yesterday.day = 1
        date = calendar.dateFromComponents(components) ?? NSDate()
        return calendar.dateByAddingComponents(yesterday, toDate: date, options: NSCalendarOptions(rawValue: 0)) ?? NSDate()
    }
    class func getYesterdayStart() -> NSDate{
        var date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: date)
        components.hour = 0
        components.minute = 0
        components.second = 0
        let yesterday = NSDateComponents()
        yesterday.day = -1
        date = calendar.dateFromComponents(components) ?? NSDate()
        return calendar.dateByAddingComponents(yesterday, toDate: date, options: NSCalendarOptions(rawValue: 0)) ?? NSDate()
    }
    class func min(date1 : NSDate, date2: NSDate) -> NSDate{
        if date1.compare(date2) == .OrderedDescending{
            return date2
        }
        return date1
    }
    class func getAWeekAgoStart() -> NSDate{
        var date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: date)
        components.hour = 0
        components.minute = 0
        components.second = 0
        let yesterday = NSDateComponents()
        yesterday.day = -7
        date = calendar.dateFromComponents(components) ?? NSDate()
        return calendar.dateByAddingComponents(yesterday, toDate: date, options: NSCalendarOptions(rawValue: 0)) ?? NSDate()
    }
    class func getDateStartByAddingDays(date: NSDate, days: Int) -> NSDate{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: date)
        components.hour = 0
        components.minute = 0
        components.second = 0
        let newDate = NSDateComponents()
        newDate.day = days
        let currentDate = calendar.dateFromComponents(components) ?? NSDate()
        return calendar.dateByAddingComponents(newDate, toDate: currentDate, options: NSCalendarOptions(rawValue: 0)) ?? NSDate()
    }
    class func getDateStart(date: NSDate) -> NSDate{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: date)
        components.hour = 0
        components.minute = 0
        components.second = 0
        return calendar.dateFromComponents(components) ?? NSDate()
    }
    class func getTodayStart() -> NSDate{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
        components.hour = 0
        components.minute = 0
        components.second = 0
        return calendar.dateFromComponents(components) ?? NSDate()
    }
    class func isTomorrow(date: NSDate) -> Bool{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.day = components.day+1
        let dateFromComponents : NSDate? = calendar.dateFromComponents(components)
        return dateStartMinutes(date) == dateStartMinutes(dateFromComponents ?? NSDate())
    }
    class func isToday(date:NSDate) -> Bool{
        return dateStartMinutes(date) == dateStartMinutes(NSDate())
    }
    class func todayStartMinutes() -> Double{
        let currentDate = NSDate()
        return dateStartMinutes(currentDate)
    }
    class func getMinutesFromDate(date: NSDate) -> Double{
        return (date.timeIntervalSince1970 ?? 0)
    }
    class func dayMinuteFromDate(date: NSDate) -> Double
    {
        let calendar = NSCalendar.currentCalendar()
        //let offset = calendar.timeZone.secondsFromGMT
        let components = calendar.components([.Hour, .Minute, .Second], fromDate: date)
        return Double(components.hour)*60.0 + Double(components.minute) + Double(components.second)/60.0
    }
    class func getDateFromMinutesSince1970(minutes: Int)->NSDate{
        return NSDate(timeIntervalSince1970: NSTimeInterval(minutes*60))
    }
    class func getCurrentTimeMinutes()-> Int{
        let currentDate = NSDate()
        return Int(currentDate.timeIntervalSince1970)/60
    }
    class func getDateTimeFormatted(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mm a"
        return formatter.stringFromDate(date)
    }
    class func getDateFormatted(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.stringFromDate(date)
    }
    class func getTimeFormatted(date: NSDate) -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.stringFromDate(date)
    }
    class func getDayTime() -> NSNumber{
        let currentDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let componets = calendar.components([.Hour], fromDate: currentDate)
        if componets.hour < 12{
            return DayTime.Morning
        }
        else if componets.hour > 19{
            return DayTime.Night
        }
        else{
            return DayTime.Afternoon
        }
    }
    class func getStringFromTime(date: NSDate) -> String?
    {
        let df = NSDateFormatter()
        df.dateFormat = "hh:mm a"
        return df.stringFromDate(date)
    }
    class func getTimeFromString(dateString: String) -> NSDate?{
        let df = NSDateFormatter()
        df.dateFormat = "hh:mm a"
        return df.dateFromString(dateString)
    }
}