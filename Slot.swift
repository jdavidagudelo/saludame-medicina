//
//  Slot.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 19/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import Foundation
import CoreData


class Slot: NSManagedObject {
    class func getDoseInventory(moc: NSManagedObjectContext, medicamento: Medicamento?) -> Slot?
    {
        let fetchRequest = NSFetchRequest(entityName: "Slot")
        if medicamento != nil{
            let predicates = [NSPredicate(format:"medicamento == %@", medicamento!)]
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            fetchRequest.predicate = compoundPredicate
        }
        do{
            var result =  try moc.executeFetchRequest(fetchRequest) as? [Slot]
            return result?.isEmpty ?? true ? nil : result![0]
        }
        catch{
            return nil
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
    class func getAll(moc: NSManagedObjectContext) -> [Slot]?
    {
        let fetchRequest = NSFetchRequest(entityName: "Slot")
        do{
            return try moc.executeFetchRequest(fetchRequest) as? [Slot]
        }
        catch{
            return []
        }
    }
    class func createInManagedObjectContext(moc: NSManagedObjectContext,
        medicamento: Medicamento?,
        slotId: NSNumber?,
        quantity: NSNumber?
        ) -> Slot {
            let slot = NSEntityDescription.insertNewObjectForEntityForName("Slot", inManagedObjectContext: moc) as! Slot
            slot.slot = slotId
            slot.quantity = quantity
            slot.medicamento = medicamento
            do {
                try moc.save()
            } catch {
                print(error)
                abort()
            }
            return slot
    }

}
