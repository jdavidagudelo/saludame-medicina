//
//  ReferenceNamePatient.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 18/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import Foundation
import CoreData


class ReferenceNamePatient: NSManagedObject {
    class func getAll(moc: NSManagedObjectContext) -> [ReferenceNamePatient]?
    {
        let fetchRequest = NSFetchRequest(entityName: "ReferenceNamePatient")
        do{
            return try moc.executeFetchRequest(fetchRequest) as? [ReferenceNamePatient]
        }
        catch{
            return []
        }
    }
    class func getById(moc: NSManagedObjectContext, id: NSNumber!) -> ReferenceNamePatient?{
        let fetchRequest = NSFetchRequest(entityName: "ReferenceNamePatient")
        let predicates = [NSPredicate(format:"id == %@", id)]
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = compoundPredicate
        do{
            var result =  try moc.executeFetchRequest(fetchRequest) as? [ReferenceNamePatient]
            return result?.isEmpty ?? true  ? nil : result?[0]
        }
        catch{
            return nil
        }
        
    }
    class func save(moc: NSManagedObjectContext, json: NSDictionary) -> ReferenceNamePatient?{
        let id = json["id"] as? NSNumber ?? -1
        var referenceName = getById(moc, id: id)
        if referenceName == nil{
            referenceName = NSEntityDescription.insertNewObjectForEntityForName("ReferenceNamePatient", inManagedObjectContext: moc) as? ReferenceNamePatient
        }
        referenceName?.id = id
        referenceName?.parameterId = json["parameterNameId"] as? NSNumber
        let prefixId = json["prefixId"] as? NSNumber ?? -1
        referenceName?.prefix = Prefix.getById(moc, id: prefixId)
        do {
            try moc.save()
        } catch {
            print(error)
            abort()
        }
        return referenceName
    }
}
