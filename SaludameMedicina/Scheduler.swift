//
//  Scheduler.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 12/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import Foundation
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