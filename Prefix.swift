//
//  Prefix.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 18/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import Foundation
import CoreData


class Prefix: NSManagedObject {
    
    class func getById(moc: NSManagedObjectContext, id: NSNumber!) -> Prefix?{
        let fetchRequest = NSFetchRequest(entityName: "Prefix")
        let predicates = [NSPredicate(format:"id == %@", id)]
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = compoundPredicate
        do{
            var result =  try moc.executeFetchRequest(fetchRequest) as? [Prefix]
            return result?.isEmpty ?? true  ? nil : result?[0]
        }
        catch{
            return nil
        }
        
    }
    class func getAll(moc: NSManagedObjectContext) -> [Prefix]?
    {
        let fetchRequest = NSFetchRequest(entityName: "Prefix")
        do{
            return try moc.executeFetchRequest(fetchRequest) as? [Prefix]
        }
        catch{
            return []
        }
    }
    
    class func save(moc: NSManagedObjectContext, json: NSDictionary) -> Prefix?{
        
        let id = json["id"] as? NSNumber ?? -1
        var prefix = getById(moc, id: id)
        if prefix == nil{
            prefix = NSEntityDescription.insertNewObjectForEntityForName("Prefix", inManagedObjectContext: moc) as? Prefix
        }
        prefix?.id = id
        prefix?.prefix = json["prefix"] as? String
        do {
            try moc.save()
        } catch {
            print(error)
            abort()
        }
        return prefix
    }
}
