//
//  DoseInventory.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 19/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import Foundation
import CoreData


class DoseInventory: NSManagedObject {
   
    class func getDoseInventory(moc: NSManagedObjectContext, medicamento: Medicamento?) -> DoseInventory?
    {
        let fetchRequest = NSFetchRequest(entityName: "DoseInventory")
        if medicamento != nil{
            let predicates = [NSPredicate(format:"medicamento == %@", medicamento!)]
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            fetchRequest.predicate = compoundPredicate
        }
        do{
            var result =  try moc.executeFetchRequest(fetchRequest) as? [DoseInventory]
            return result?.isEmpty ?? true ? nil : result![0]
        }
        catch{
            return nil
        }
    }
    class func consumeDose(moc:NSManagedObjectContext, medicamento: Medicamento?){
        let doseInventory = getDoseInventory(moc, medicamento: medicamento)
        doseInventory?.currentAmount = Int((doseInventory?.currentAmount) ?? 0) - Int(doseInventory?.medicamento?.dosis ?? 0)
        doseInventory?.consumedAmount = Int((doseInventory?.consumedAmount) ?? 0) + Int(doseInventory?.medicamento?.dosis ?? 0)
        DoseInventory.save(moc)
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
    class func getAll(moc: NSManagedObjectContext) -> [DoseInventory]?
    {
        let fetchRequest = NSFetchRequest(entityName: "DoseInventory")
        do{
            return try moc.executeFetchRequest(fetchRequest) as? [DoseInventory]
        }
        catch{
            return []
        }
    }
    class func createInManagedObjectContext(moc: NSManagedObjectContext,
        medicamento: Medicamento?,
        currentAmount: NSNumber?,
        consumedAmount: NSNumber?
        ) -> DoseInventory {
            let doseInventory = NSEntityDescription.insertNewObjectForEntityForName("DoseInventory", inManagedObjectContext: moc) as! DoseInventory
            doseInventory.currentAmount = currentAmount
            doseInventory.consumedAmount = consumedAmount
            do {
                try moc.save()
            } catch {
                print(error)
                abort()
            }
            return doseInventory
    }
}
