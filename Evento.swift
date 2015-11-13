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
            moc.deleteObject(evento)
            try moc.save()
        } catch {
            print(error)
            abort()
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
    class func deleteAll(moc: NSManagedObjectContext){
        for event in getAll(moc) ?? [Evento](){
            Evento.delete(moc, evento: event)
        }
    }
    class func deleteAll(moc: NSManagedObjectContext, medicamento: Medicamento?){
        for event in getEvents(moc, medicamento: medicamento) ?? [Evento](){
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
    class func getEvents(moc: NSManagedObjectContext, medicamento: Medicamento?) -> [Evento]?
    {
        let fetchRequest = NSFetchRequest(entityName: "Evento")
        if medicamento != nil{
            let predicates = [NSPredicate(format:"medicamento == %@", medicamento!)]
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
    class func archiveEvents(moc: NSManagedObjectContext, medicamento: Medicamento?){
        let events = getCyclicEvents(moc, medicamento: medicamento)
        for event in events ?? [Evento](){
            event.state = EventState.Archived
        }
        do {
            try moc.save()
        } catch {
            print(error)
            abort()
        }
    }
    class func createInManagedObjectContext(moc: NSManagedObjectContext, medicamento: Medicamento?, cycle: NSNumber?, time: NSNumber?,
        type: NSNumber?, state: NSNumber?) -> Evento {
            let evento = NSEntityDescription.insertNewObjectForEntityForName("Evento", inManagedObjectContext: moc) as! Evento
            evento.medicamento = medicamento
            evento.cycle = cycle
            evento.time = time
            evento.type = type
            evento.state = state
            do {
                try moc.save()
            } catch {
                print(error)
                abort()
            }
            return evento
    }
    
}
