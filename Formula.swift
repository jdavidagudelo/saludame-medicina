//
//  Formula.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 30/10/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import Foundation
import CoreData


class Formula: NSManagedObject {

    
    class func delete(moc: NSManagedObjectContext, formula: Formula){
        do {
            moc.deleteObject(formula)
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
    class func getAll(moc: NSManagedObjectContext) -> [Formula]?
    {
        let fetchRequest = NSFetchRequest(entityName: "Formula")
        do{
            return try moc.executeFetchRequest(fetchRequest) as? [Formula]
        }
        catch{
            return []
        }
    }
    class func createInManagedObjectContext(moc: NSManagedObjectContext, fecha: NSDate?, numero:String?, recomendaciones:String?, institucion: String?, nombreMedico:String?) -> Formula {
        let formula = NSEntityDescription.insertNewObjectForEntityForName("Formula", inManagedObjectContext: moc) as! Formula
        formula.fecha = fecha
        formula.institucion = institucion
        formula.numero = numero
        formula.recomendaciones = recomendaciones
        formula.nombreMedico = nombreMedico
        do {
            try moc.save()
        } catch {
            print(error)
            abort()
        }
        return formula
    }
    class func getText(formula:Formula?, formulaName: String = "Fórmula", defaultFormula: String = "Sin fórmula") -> String{
        if let f = formula {
            return "\(formulaName) #: \(f.numero ?? "") - \(f.institucion ?? "")"
        }
        return "\(formulaName) #: - \(defaultFormula)"
    }
}
