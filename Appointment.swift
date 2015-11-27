//
//  Appointment.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 26/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import Foundation
import CoreData


class Appointment: NSManagedObject {
    
    class func delete(moc: NSManagedObjectContext, appointment: Appointment){
        do {
            moc.deleteObject(appointment)
            try moc.save()
        } catch {
            print(error)
            abort()
        }
    }
    
    class func getNextAppointment(moc: NSManagedObjectContext) -> Appointment?{
        let appointments = getAll(moc)
        
        if let empty =  appointments?.isEmpty
        {
            if empty{
                return nil
            }
        }
        return appointments?[0]
    }
    class func getById(moc: NSManagedObjectContext, id: NSNumber!) -> Appointment?{
        let fetchRequest = NSFetchRequest(entityName: "Appointment")
        let predicates = [NSPredicate(format:"id == %@", id)]
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = compoundPredicate
        do{
            var result =  try moc.executeFetchRequest(fetchRequest) as? [Appointment]
            return result?.isEmpty ?? true  ? nil : result?[0]
        }
        catch{
            return nil
        }
        
    }
    class func removeAll(moc: NSManagedObjectContext){
        let appointments = getAll(moc)
        for appointment in appointments ?? []{
            delete(moc, appointment: appointment)
        }
    }
    private class func order(d1: NSDate, d2: NSDate) -> Bool{
        let date = NSDate()
        if date.compare(d1) == .OrderedDescending && date.compare(d2) == .OrderedAscending {
            return false
        }
        if date.compare(d2) == .OrderedDescending && date.compare(d1) == .OrderedAscending{
            return true
        }
        return d1.compare(d2) == .OrderedAscending
    }
    class func getAll(moc: NSManagedObjectContext) -> [Appointment]?
    {
        let fetchRequest = NSFetchRequest(entityName: "Appointment")
        do{
            var result = try moc.executeFetchRequest(fetchRequest) as? [Appointment]
            result?.sortInPlace(){e1,e2 in order(e1.date ?? NSDate() , d2: e2.date ?? NSDate())}
            return result
        }
        catch{
            return []
        }
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
    class func save(moc: NSManagedObjectContext, doctorName: String?, place: String?, date: NSDate?, description: String?) -> Appointment?{
        
        let appointment = NSEntityDescription.insertNewObjectForEntityForName("Appointment", inManagedObjectContext: moc) as? Appointment
        appointment?.doctorName = doctorName
        appointment?.place = place
        appointment?.date = date
        appointment?.descriptionText = description
        save(moc)
        return appointment
    }
}
