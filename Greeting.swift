//
//  Greeting.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 18/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import Foundation
import CoreData


class Greeting: NSManagedObject {
    class func getById(moc: NSManagedObjectContext, id: NSNumber!) -> Greeting?{
        let fetchRequest = NSFetchRequest(entityName: "Greeting")
        let predicates = [NSPredicate(format:"id == %@", id)]
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = compoundPredicate
        do{
            var result =  try moc.executeFetchRequest(fetchRequest) as? [Greeting]
            return result?.isEmpty ?? true  ? nil : result?[0]
        }
        catch{
            return nil
        }
    }
    class func getAll(moc: NSManagedObjectContext) -> [Greeting]?
    {
        let fetchRequest = NSFetchRequest(entityName: "Greeting")
        do{
            return try moc.executeFetchRequest(fetchRequest) as? [Greeting]
        }
        catch{
            return []
        }
    }
    class func getFilteredGreetings(moc: NSManagedObjectContext, protocolId: NSNumber, hourId: NSNumber, genreId: NSNumber) -> [Greeting]?{
        let fetchRequest = NSFetchRequest(entityName: "Greeting")
        let predicateHour = NSCompoundPredicate(orPredicateWithSubpredicates: [NSPredicate(format:"hourId == %@", hourId),
            NSPredicate(format:"hourId == 4")])
        let predicateGenre = NSCompoundPredicate(orPredicateWithSubpredicates: [NSPredicate(format:"genreId == %@", genreId),
            NSPredicate(format:"genreId == 1")])
        let predicates = [predicateHour,predicateGenre,
            NSPredicate(format:"protocolId == %@", protocolId)]
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = compoundPredicate
        do{
            return try moc.executeFetchRequest(fetchRequest) as? [Greeting]
        }
        catch{
            return []
        }
    }
    class func save(moc: NSManagedObjectContext, json: NSDictionary) -> Greeting?{
        
        let id = json["id"] as? NSNumber ?? -1
        var greeting = getById(moc, id: id)
        if greeting == nil{
            greeting = NSEntityDescription.insertNewObjectForEntityForName("Greeting", inManagedObjectContext: moc) as? Greeting
        }
        greeting?.id = id
        greeting?.hourId = json["hourId"] as? NSNumber
        greeting?.genreId = json["genreId"] as? NSNumber
        greeting?.message = json["message"] as? String
        greeting?.protocolId = json["protocolId"] as? NSNumber
        let referenceNameId = json["referenceId"] as? NSNumber ?? -1
        greeting?.referenceName = ReferenceNamePatient.getById(moc, id: referenceNameId)
        do {
            try moc.save()
        } catch {
            print(error)
            abort()
        }
        return greeting
    }
}
