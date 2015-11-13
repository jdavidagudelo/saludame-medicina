//: Playground - noun: a place where people can play

import Foundation

var str = "Hello, playground"
var df = NSDateFormatter()
df.dateFormat = "hh:mm a"
var date = df.stringFromDate(NSDate())
print("\(date)")
var components = NSDateComponents()
var calendar = NSCalendar.currentCalendar()
components.hour = 23
components.minute = 59
components.second = 0
var dateFromComponents = NSCalendar.currentCalendar().dateFromComponents(components)
df.stringFromDate(dateFromComponents!)
