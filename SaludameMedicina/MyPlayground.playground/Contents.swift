//: Playground - noun: a place where people can play

import Foundation
import UIKit

var str = "Hello, playground"
var df = NSDateFormatter()
df.dateFormat = "dd-MM-yyyy HH:mm:ss"
var date = df.dateFromString("1-1-2000 17:00:00")
date?.timeIntervalSince1970
print("\(date?.timeIntervalSince1970)")
class TimeUtil{
    class func secondsToMinutes(secondsSince1970: NSNumber) -> NSNumber{
        return Double(secondsSince1970)/60.0
    }
    class func todayStartMinutes1() -> NSNumber{
        let currentDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: currentDate)
        components.hour = 0
        components.minute = 0
        components.second = 0
        //let offset = calendar.timeZone.secondsFromGMT
        return Double(calendar.dateFromComponents(components)?.timeIntervalSince1970 ?? 0.0)/60.0
    }
    class func dayMinuteFromDate(date: NSDate) -> Double
    {
        let calendar = NSCalendar.currentCalendar()
        let currentDate = NSDate()
        //let offset = calendar.timeZone.secondsFromGMT
        let components = calendar.components([.Hour, .Minute, .Second], fromDate: currentDate)
        return Double(components.hour)*60.0 + Double(components.minute) + Double(components.second)/60.0
    }
}
TimeUtil.todayStartMinutes1()
let calendar = NSCalendar.currentCalendar()
let components = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
components.hour = 0
components.minute = 0
components.second = 0
let offset = calendar.timeZone.secondsFromGMT
let minute = TimeUtil.dayMinuteFromDate(NSDate())

class Scheduler{
    class func  distibuteOverDay(timesDay: Int, period: Int, wakeUpTime: Double) -> [Int]
    {
        var time = Int(wakeUpTime)
        var result = [Int]()
        for _ in 1...timesDay{
            result.append(time)
            time += (period*60)
            if time/60 >= 24
            {
                time = time - (24*60)
            }
        }
        result.sortInPlace()
        return result
    }
}

Scheduler.distibuteOverDay(8, period: 3, wakeUpTime: 0)

var minutes = TimeUtil.dayMinuteFromDate(NSDate())

df.dateFormat = "hh:mm a"

df.stringFromDate(NSDate())
