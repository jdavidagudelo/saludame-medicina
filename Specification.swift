//
//  Specification.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 18/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import Foundation
import CoreData


class Specification: NSManagedObject {
    class func getById(moc: NSManagedObjectContext, id: NSNumber!) -> Specification?{
        let fetchRequest = NSFetchRequest(entityName: "Specification")
        let predicates = [NSPredicate(format:"id == %@", id)]
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = compoundPredicate
        do{
            var result =  try moc.executeFetchRequest(fetchRequest) as? [Specification]
            return result?.isEmpty ?? true  ? nil : result?[0]
        }
        catch{
            return nil
        }
        
    }
    class func getAll(moc: NSManagedObjectContext) -> [Specification]?
    {
        let fetchRequest = NSFetchRequest(entityName: "Specification")
        do{
            return try moc.executeFetchRequest(fetchRequest) as? [Specification]
        }
        catch{
            return []
        }
    }
    
    class func save(moc: NSManagedObjectContext, json: NSDictionary) -> Specification?{
        
        let id = json["id"] as? NSNumber ?? -1
        var specification = getById(moc, id: id)
        if specification == nil{
            specification = NSEntityDescription.insertNewObjectForEntityForName("Specification", inManagedObjectContext: moc) as? Specification
        }
        specification?.id = id
        specification?.text = json["text"] as? String
        do {
            try moc.save()
        } catch {
            print(error)
            abort()
        }
        return specification
    }
}
