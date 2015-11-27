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
        let uuid : String? = (NSUserDefaults.standardUserDefaults().objectForKey(Notifications.NotificationIdKey) as? String) ?? NSUUID().UUIDString
        NSUserDefaults.standardUserDefaults().setObject(uuid, forKey: Notifications.NotificationIdKey)
        notification.alertBody = "Notificacion de medicamento" // text that will be displayed in the notification
        notification.alertAction = "Abrir" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = date ?? NSDate()
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        print("\(evento.objectID.URIRepresentation())")
        notification.userInfo = [Notifications.NotificationIdKey: uuid ?? "",
            Notifications.EventNotificationIdKey: "\(evento.objectID.URIRepresentation())"]
        notification.category = "MEDICATION_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    class func cancelAllNotifications(){
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    class func cancelEventNotification(){
        let uuid : String? = (NSUserDefaults.standardUserDefaults().objectForKey(Notifications.NotificationIdKey) as? String) ?? nil
        print("the uuid = \(uuid)")
        if uuid != nil{
            for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] {
                print (notification.userInfo![Notifications.NotificationIdKey] as? String == uuid)
                if (notification.userInfo![Notifications.NotificationIdKey] as? String == uuid) {
                    UIApplication.sharedApplication().cancelLocalNotification(notification)
                }
            }
        }
    }
    class func updateNotifications(managedObjectContext: NSManagedObjectContext){
        //remaining events this day
        if var events = Evento.getEventsFromMinute(managedObjectContext, date: NSDate()){
            if !events.isEmpty
            {
                cancelEventNotification()
                let event = events[0]
                createNotification(event)
            }
        }
    }
}