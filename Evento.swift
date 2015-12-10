//
//  Evento.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 12/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import Foundation
import CoreData


class Evento: NSManagedObject {
    
    class func delete(moc: NSManagedObjectContext, evento: Evento){
        do {
            Notifier.cancelEventNotification(evento)
            moc.deleteObject(evento)
            try moc.save()
        } catch {
            print(error)
            abort()
        }
    }
    class func getEventById(moc: NSManagedObjectContext, id: NSManagedObjectID) -> Evento?{
        return moc.objectWithID(id) as? Evento
    }
    class func save(moc: NSManagedObjectContext)
    {
        do {
            try moc.save()
        } catch {
            print(error)
            abort()
        }
    }
    class func setAnswer(moc: NSManagedObjectContext, event: Evento?, answer: NSNumber!){
        event?.response = answer
        event?.responseTime = NSDate()
        Evento.save(moc)
    }
    class func deleteAll(moc: NSManagedObjectContext){
        for event in getAll(moc) ?? [Evento](){
            Evento.delete(moc, evento: event)
        }
    }
    class func deleteAll(moc: NSManagedObjectContext, medicamento: Medicamento?){
        for event in getAllEvents(moc, medicamento: medicamento) ?? [Evento](){
            Evento.delete(moc, evento: event)
        }
    }
    class func getAll(moc: NSManagedObjectContext) -> [Evento]?
    {
        let fetchRequest = NSFetchRequest(entityName: "Evento")
        do{
            return try moc.executeFetchRequest(fetchRequest) as? [Evento]
        }
        catch{
            return []
        }
    }
    
    class func getEventsActive(moc: NSManagedObjectContext) -> [Evento]?
    {
        let fetchRequest = NSFetchRequest(entityName: "Evento")
        let predicates = [NSPredicate(format: "state == %@", EventState.Active)]
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = compoundPredicate
        do{
            var result =  try moc.executeFetchRequest(fetchRequest) as? [Evento]
            result?.sortInPlace(){e1,e2 in e1.eventDate!.compare( e2.eventDate!) == .OrderedAscending}
            return result
        }
        catch{
            return []
        }
    }
    class func getAllEvents(moc: NSManagedObjectContext, medicamento: Medicamento?) -> [Evento]?
    {
        let fetchRequest = NSFetchRequest(entityName: "Evento")
        if medicamento != nil{
            let predicates = [NSPredicate(format:"medicamento == %@", medicamento!)]
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            fetchRequest.predicate = compoundPredicate
        }
        do{
            var result =  try moc.executeFetchRequest(fetchRequest) as? [Evento]
            result?.sortInPlace(){e1,e2 in e1.eventDate?.compare( e2.eventDate ?? NSDate()) == .OrderedAscending}
            return result
        }
        catch{
            return []
        }
    }
   
    class func getEvents(moc: NSManagedObjectContext, medicamento: Medicamento?) -> [Evento]?
    {
        let fetchRequest = NSFetchRequest(entityName: "Evento")
        if medicamento != nil{
            let predicates = [NSPredicate(format:"medicamento == %@", medicamento!), NSPredicate(format: "state == %@", EventState.Active)]
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            fetchRequest.predicate = compoundPredicate
        }
        do{
            var result =  try moc.executeFetchRequest(fetchRequest) as? [Evento]
            result?.sortInPlace(){e1,e2 in e1.eventDate!.compare( e2.eventDate!) == .OrderedAscending}
            return result
        }
        catch{
            return []
        }
    }
    class func getCyclicEvents(moc: NSManagedObjectContext, medicamento: Medicamento?) -> [Evento]?{
        let fetchRequest = NSFetchRequest(entityName: "Evento")
        if medicamento != nil{
            let predicates = [NSPredicate(format:"medicamento == %@", medicamento!), NSPredicate(format: "state == %@", EventState.Active),
            NSPredicate(format: "cycle != %@", EventPeriod.Unique)]
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            fetchRequest.predicate = compoundPredicate
        }
        else{
            let predicates = [NSPredicate(format: "state == %@", EventState.Active),
                NSPredicate(format: "cycle != %@", EventPeriod.Unique)]
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            fetchRequest.predicate = compoundPredicate
        }
        do{
            var result =  try moc.executeFetchRequest(fetchRequest) as? [Evento]
            result?.sortInPlace(){e1,e2 in Int(e1.time!) <= Int(e2.time!)}
            return result
        }
        catch{
            return []
        }
    }
    class func updateEvents(moc: NSManagedObjectContext){
        for event in getEventsUntilMinute(moc, date: NSDate()) ?? []{
            updateNextEvent(moc, event: event)
        }
    }
    class func deleteEventsArchivedUntilMinute(moc: NSManagedObjectContext, date: NSDate!, startDate: NSDate!, endDate: NSDate!){
        for event in getEventsArchivedUntilMinute(moc, date: date) ?? []{
            event.state = EventState.Deleted
        }
        save(moc)
    }
    class func getEventsArchivedBetween(moc: NSManagedObjectContext, startDate: NSDate!, endDate: NSDate!)->[Evento]?{
        let fetchRequest = NSFetchRequest(entityName: "Evento")
        let predicates = [NSPredicate(format:"eventDate < %@", endDate), NSPredicate(format:"eventDate > %@", startDate),
            NSPredicate(format: "state == %@", EventState.Archived), NSPredicate(format: "response == %@", EventAnswer.Pending)]
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = compoundPredicate
        do{
            var result =  try moc.executeFetchRequest(fetchRequest) as? [Evento]
            result?.sortInPlace(){e1,e2 in e1.eventDate!.compare(e2.eventDate!) == .OrderedAscending}
            return result
        }
        catch{
            return []
        }
    }
    class func getEventsArchivedUntilMinute(moc: NSManagedObjectContext, date: NSDate!)->[Evento]?{
        let fetchRequest = NSFetchRequest(entityName: "Evento")
        let predicates = [NSPredicate(format:"eventDate < %@", date), NSPredicate(format: "state == %@", EventState.Archived), NSPredicate(format: "response == %@", EventAnswer.Pending)]
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = compoundPredicate
        do{
            var result =  try moc.executeFetchRequest(fetchRequest) as? [Evento]
            result?.sortInPlace(){e1,e2 in e1.eventDate!.compare(e2.eventDate!) == .OrderedAscending}
            return result
        }
        catch{
            return []
        }
    }
    class func getEventsUntilMinute(moc: NSManagedObjectContext, date: NSDate!)->[Evento]?{
        let fetchRequest = NSFetchRequest(entityName: "Evento")
        let predicates = [NSPredicate(format:"eventDate < %@", date), NSPredicate(format: "state == %@", EventState.Active), NSPredicate(format: "response == %@", EventAnswer.Pending)]
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = compoundPredicate
        do{
            var result =  try moc.executeFetchRequest(fetchRequest) as? [Evento]
            result?.sortInPlace(){e1,e2 in e1.eventDate!.compare(e2.eventDate!) == .OrderedAscending}
            return result
        }
        catch{
            return []
        }
    }
    class func getEventsFromMinute(moc: NSManagedObjectContext, date: NSDate!)->[Evento]?{
        let fetchRequest = NSFetchRequest(entityName: "Evento")
        let predicates = [NSPredicate(format:"eventDate > %@", date), NSPredicate(format: "state == %@", EventState.Active),
            NSPredicate(format: "response == %@", EventAnswer.Pending)]
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = compoundPredicate
        do{
            var result =  try moc.executeFetchRequest(fetchRequest) as? [Evento]
            result?.sortInPlace(){e1,e2 in e1.eventDate!.compare(e2.eventDate!) == .OrderedAscending}
            return result
        }
        catch{
            return []
        }
    }
    class func delayEvent(moc: NSManagedObjectContext, minutes: NSNumber, event: Evento?){
        let time = (Int(event?.time ?? 0)+Int(minutes))%1440
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.minute = Int(minutes)
        let date = calendar.dateByAddingComponents(components, toDate: event?.eventDate ?? NSDate(), options: NSCalendarOptions(rawValue: 0))
        createInManagedObjectContext(moc, medicamento: event?.medicamento, cycle: EventPeriod.Unique, time: time, type: event?.type,
            state: EventState.Active, eventDate: date)
    }
    class func archiveEvents(moc: NSManagedObjectContext, medicamento: Medicamento?){
        let events = getAllEvents(moc, medicamento: medicamento)
        let date = NSDate()
        for event in events ?? [Evento](){
            let order = date.compare(event.eventDate ?? NSDate())
            if order == .OrderedAscending{
                event.state = EventState.Deleted
            }
            else{
                event.state = EventState.Archived
            }
            Notifier.cancelEventNotification(event)
        }
        save(moc)
    }
    class func archiveEvent(moc: NSManagedObjectContext, event: Evento?){
        let date = NSDate()
        let order = date.compare(event?.eventDate ?? NSDate())
        if order == .OrderedAscending{
            event?.state = EventState.Deleted
        }else{
            event?.state = EventState.Archived
        }
        if event != nil{
            Notifier.cancelEventNotification(event!)
        }
        Evento.save(moc)
    }
    /**
     * This method archives the current event and generates an event that will be triggered the next day if the
     * period is in hours or the next number of days if the period is in days
     */
    class func updateNextEvent(moc: NSManagedObjectContext, event: Evento?){
        if event?.cycle == EventPeriod.Daily{
            var days = 1
            if event?.medicamento?.unidadTiempoPeriodicidad == IntervalConstants.DaysInterval{
                days = Int((event?.medicamento?.periodicidad) ?? 1)
            }
            let calendar = NSCalendar.currentCalendar()
            let components = NSDateComponents()
            components.day = days
            let currentDate = NSDate()
            let date = calendar.dateByAddingComponents(components, toDate: event?.eventDate ?? currentDate, options: NSCalendarOptions(rawValue: 0))
            if date?.compare(event?.medicamento?.fechaFin ?? currentDate) == .OrderedAscending {
                let nextEvent = createInManagedObjectContext(moc, medicamento: event?.medicamento, cycle: event?.cycle, time: event?.time, type: event?.type,
                    state: EventState.Active, eventDate: date)
                if nextEvent.eventDate?.compare(currentDate) == .OrderedAscending{
                    //happens if the app was killed, so it is possible some events were lost
                    //just tries to create them and update their date
                    updateNextEvent(moc, event: nextEvent)
                }
            }
        }
        archiveEvent(moc, event:  event)
    }
    class func getNextEvent(moc: NSManagedObjectContext) -> Evento?{
        let events = getEventsFromMinute(moc, date: NSDate())
        for event in events!{
            print(event.description)
        }
        if let empty =  events?.isEmpty
        {
            if empty{
                return nil
            }
        }
        return events?[0]
    }
    class func createInManagedObjectContext(moc: NSManagedObjectContext, medicamento: Medicamento?, cycle: NSNumber?, time: NSNumber?,
        type: NSNumber?, state: NSNumber?, eventDate: NSDate?) -> Evento {
            
            let evento = NSEntityDescription.insertNewObjectForEntityForName("Evento", inManagedObjectContext: moc) as! Evento
            evento.medicamento = medicamento
            evento.cycle = cycle
            evento.time = time
            evento.type = type
            evento.state = state
            evento.eventDate = eventDate
            evento.response = EventAnswer.Pending
            save(moc)
            return evento
    }
    class func getEventsSameDate(moc: NSManagedObjectContext, id: NSManagedObjectID) -> [Evento]{
        return getEventsWithDate(moc, date: getEventById(moc, id: id)?.eventDate ?? NSDate())
    }
    class func getEventsWithDate(moc: NSManagedObjectContext, date: NSDate) -> [Evento]{
        let fetchRequest = NSFetchRequest(entityName: "Evento")
        let predicates = [NSPredicate(format:"eventDate == %@", date),
            NSPredicate(format: "state == %@", EventState.Active), NSPredicate(format: "response == %@", EventAnswer.Pending)]
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = compoundPredicate
        do{
            var result =  try moc.executeFetchRequest(fetchRequest) as? [Evento]
            result?.sortInPlace(){e1,e2 in e1.eventDate!.compare(e2.eventDate!) == .OrderedAscending}
            return result ?? []
        }
        catch{
            return []
        }
    }
    class func getAdherenceLevelCode(moc: NSManagedObjectContext, startDate: NSDate, endDate: NSDate) -> NSNumber!{
        let p = adherenceLevel(moc, startDate: startDate, endDate: endDate)
        print("Some text = \(p)")
        if p > 0.76{
            return AdherenceLevel.High
        }
        else if p < 0.65{
            return AdherenceLevel.Low
        }
        return AdherenceLevel.Average
    }
    class func getAdherenceLevelCodeAWeekAgo(moc: NSManagedObjectContext) -> NSNumber!{
        return getAdherenceLevelCode(moc, startDate: TimeUtil.getAWeekAgoStart(), endDate: NSDate())
    }
    class func getAdherenceLevelCodeToday(moc: NSManagedObjectContext) -> NSNumber!{
        return getAdherenceLevelCode(moc, startDate: TimeUtil.getTodayStart(), endDate: NSDate())
    }
    class func getAdherenceLevelCodeYesterday(moc: NSManagedObjectContext) -> NSNumber!{
        return getAdherenceLevelCode(moc, startDate: TimeUtil.getYesterdayStart(), endDate: NSDate())
    }
    class func adherenceLevelAWeekAgo(moc: NSManagedObjectContext) -> Double{
        return adherenceLevel(moc, startDate: TimeUtil.getAWeekAgoStart(), endDate: NSDate())
    }
    class func adherenceLevelYesterday(moc: NSManagedObjectContext) -> Double{
        return adherenceLevel(moc, startDate: TimeUtil.getYesterdayStart(), endDate: NSDate())
    }
    class func adherenceLevelToday(moc: NSManagedObjectContext) -> Double{
        return adherenceLevel(moc, startDate: TimeUtil.getTodayStart(), endDate: NSDate())
    }
    class func adherenceLevel(moc: NSManagedObjectContext, startDate: NSDate, endDate: NSDate) -> Double{
        let allEvents = Double(getEventsBetween(moc, startDate: startDate, endDate: endDate).count)
        let acceptedEvents = Double(getEventsAcceptedBetween(moc, startDate: startDate, endDate: endDate).count)
        print("All events = \(allEvents) Accepted Events = \(acceptedEvents)")
        return acceptedEvents/allEvents
    }
    class func getEventsAcceptedBetween(moc: NSManagedObjectContext, startDate: NSDate, endDate: NSDate) -> [Evento]{
        let fetchRequest = NSFetchRequest(entityName: "Evento")
        let predicates = [NSPredicate(format:"eventDate > %@", startDate), NSPredicate(format:"eventDate < %@", endDate),
            NSPredicate(format: "response == %@", EventAnswer.Accepted), NSPredicate(format: "type == %@", EventType.Medication),
            NSPredicate(format: "state != %@", EventState.Deleted)]
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = compoundPredicate
        do{
            var result =  try moc.executeFetchRequest(fetchRequest) as? [Evento]
            result?.sortInPlace(){e1,e2 in e1.eventDate!.compare(e2.eventDate!) == .OrderedAscending}
            return result ?? []
        }
        catch{
            return []
        }
        
    }
    class func getAllMedicationEventsBetween(moc: NSManagedObjectContext, startDate: NSDate, endDate: NSDate, medication: Medicamento?) -> [Evento]{
        
        let fetchRequest = NSFetchRequest(entityName: "Evento")
        if let m = medication{
            let predicates = [NSPredicate(format:"eventDate > %@", startDate), NSPredicate(format:"eventDate < %@", endDate),
                NSPredicate(format: "type == %@", EventType.Medication),NSPredicate(format: "medicamento == %@", m),
                NSPredicate(format: "state != %@", EventState.Deleted)]
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            fetchRequest.predicate = compoundPredicate
        }
        do{
            var result =  try moc.executeFetchRequest(fetchRequest) as? [Evento]
            result?.sortInPlace(){e1,e2 in e1.eventDate!.compare(e2.eventDate!) == .OrderedAscending}
            return result ?? []
        }
        catch{
            return []
        }
    }
    class func getAllMedicationEventsBetween(moc: NSManagedObjectContext, startDate: NSDate, endDate: NSDate) -> [Evento]{
        let fetchRequest = NSFetchRequest(entityName: "Evento")
        let predicates = [NSPredicate(format:"eventDate > %@", startDate), NSPredicate(format:"eventDate < %@", endDate),
            NSPredicate(format: "type == %@", EventType.Medication),
            NSPredicate(format: "state != %@", EventState.Deleted)]
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = compoundPredicate
        do{
            var result =  try moc.executeFetchRequest(fetchRequest) as? [Evento]
            result?.sortInPlace(){e1,e2 in e1.eventDate!.compare(e2.eventDate!) == .OrderedAscending}
            return result ?? []
        }
        catch{
            return []
        }
    }
    class func getEventsBetween(moc: NSManagedObjectContext, startDate: NSDate, endDate: NSDate) -> [Evento]{
        let fetchRequest = NSFetchRequest(entityName: "Evento")
        let predicates = [NSPredicate(format:"eventDate > %@", startDate), NSPredicate(format:"eventDate < %@", endDate),
            NSPredicate(format: "response != %@", EventAnswer.Delayed), NSPredicate(format: "type == %@", EventType.Medication),
            NSPredicate(format: "state != %@", EventState.Deleted)]
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = compoundPredicate
        do{
            var result =  try moc.executeFetchRequest(fetchRequest) as? [Evento]
            result?.sortInPlace(){e1,e2 in e1.eventDate!.compare(e2.eventDate!) == .OrderedAscending}
            return result ?? []
        }
        catch{
            return []
        }

    }
    
    
}
