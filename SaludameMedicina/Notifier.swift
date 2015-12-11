//
//  Notifier.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 20/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Notifier{
    class func createNotification(evento:Evento){
        let date = TimeUtil.dateFromMinutesOfDay(Int((evento.time) ?? 0), date: NSDate())
        let notification = UILocalNotification()
        let uuid = "\(evento.objectID.URIRepresentation())"
        //NSUserDefaults.standardUserDefaults().setObject(uuid, forKey: Notifications.NotificationIdKey)
        notification.alertBody = "\(NSLocalizedString("eventNotificationBody", tableName: "localization",comment: "Event notification title"))\(evento.medicamento?.nombre ?? "")"
        notification.alertAction = NSLocalizedString("eventNotificationAction", tableName: "localization",comment: "Event notification action")
        notification.fireDate = date ?? NSDate()
        notification.applicationIconBadgeNumber = 0
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = [Notifications.NotificationIdKey: uuid ?? "",
            Notifications.EventNotificationIdKey: "\(evento.objectID.URIRepresentation())"]
        notification.category = "MEDICATION_CATEGORY"
        if evento.medicamento?.unidadTiempoPeriodicidad == IntervalConstants.HoursInterval{
            notification.repeatInterval = .Day
        }
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    class func cancelAllNotifications(){
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    class func cancelEventNotification(event: Evento){
        let uuid : String? = "\(event.objectID.URIRepresentation())"
        if uuid != nil{
            for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] {
                if (notification.userInfo![Notifications.NotificationIdKey] as? String == uuid) {
                    UIApplication.sharedApplication().cancelLocalNotification(notification)
                }
            }
        }
    }
    class func updateNotifications(managedObjectContext: NSManagedObjectContext){
        //remaining events this day
        if let events = Evento.getEventsFromMinute(managedObjectContext, date: NSDate()){
            for event in events
            {
                createNotification(event)
            }
        }
    }
}