//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
let diceRoll = Int(arc4random_uniform(6) + 1)
"some $".stringByReplacingOccurrencesOfString("$", withString: "Whatever")

func getAWeekAgoStart() -> NSDate{
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
func getYesterdayStart() -> NSDate{
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
func getTodayStart() -> NSDate{
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
    components.hour = 0
    components.minute = 0
    components.second = 0
    return calendar.dateFromComponents(components) ?? NSDate()
}
getYesterdayStart()
getTodayStart()
getAWeekAgoStart()
let x = [["a"], ["b", "c", "d"]]
print(x[1][2])
