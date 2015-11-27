//
//  Evento+CoreDataProperties.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 12/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Evento {

    @NSManaged var cycle: NSNumber?
    @NSManaged var time: NSNumber?
    @NSManaged var type: NSNumber?
    @NSManaged var postponed: NSNumber?
    @NSManaged var state: NSNumber?
    @NSManaged var response: NSNumber?
    @NSManaged var responseTime: NSDate?
    @NSManaged var medicamento: Medicamento?
    @NSManaged var notificationTime: NSNumber?
    @NSManaged var eventDate : NSDate?
    var dateText: String{
        get{
            var dateText = ""
            if let date = eventDate{
                if TimeUtil.isToday(date){
                    dateText = "\(NSLocalizedString("eventTodayTitle", tableName: "localization",comment: "Event today")) \(TimeUtil.getTimeFormatted(date))"
                }else if TimeUtil.isTomorrow(date){
                    dateText = "\(NSLocalizedString("eventTomorrow", tableName: "localization",comment: "Event tomorrow")) \(TimeUtil.getTimeFormatted(date))"
                }
                else{
                    dateText = TimeUtil.getDateTimeFormatted(date)
                }
            }
            return dateText
        }
    }
    var nameText: String{
        get{
            return "\(NSLocalizedString("eventTakeMedication", tableName: "localization", comment: "Event take medication")) \(medicamento?.nombre ?? "")"
        }
    }
    override var description: String{
        get{
            if type ==  EventType.Appointment || type == EventType.SelfCheck{
                return ""
            }
            if type == EventType.Habit || type == EventType.Medication{
                if medicamento == nil{
                    return NSLocalizedString("noEventAvailable", tableName: "localization",comment: "No event available information")
                }
                else{
                    return "\(nameText) \(dateText)"
                }
            }
            return ""
        }
    }
}
