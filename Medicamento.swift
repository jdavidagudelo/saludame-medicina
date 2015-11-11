//
//  Medicamento.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 10/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import Foundation
import CoreData


class Medicamento: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func delete(moc: NSManagedObjectContext, medicamento: Medicamento){
        do {
            moc.deleteObject(medicamento)
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
    class func getAll(moc: NSManagedObjectContext) -> [Medicamento]?
    {
        let fetchRequest = NSFetchRequest(entityName: "Medicamento")
        do{
            return try moc.executeFetchRequest(fetchRequest) as? [Medicamento]
        }
        catch{
            return []
        }
    }
    class func createInManagedObjectContext(moc: NSManagedObjectContext,
        cantidad: NSNumber?,
        periodicidad: NSNumber?,
        dosis: NSNumber?,
        concentracion: NSNumber?,
        indicaciones: String?,
        via: String?,
        nombre: String?,
        unidadTiempoPeriodicidad: String?,
        presentacion: String?,
        fechaInicio: NSDate?,
        fechaFin: NSDate?,
        duracion: NSNumber?,
        formula: Formula?
        ) -> Medicamento {
            let medicamento = NSEntityDescription.insertNewObjectForEntityForName("Medicamento", inManagedObjectContext: moc) as! Medicamento
            medicamento.cantidad = cantidad
            medicamento.periodicidad = periodicidad
            medicamento.dosis = dosis
            medicamento.concentracion = concentracion
            medicamento.indicaciones = indicaciones
            medicamento.via = via
            medicamento.nombre = nombre
            medicamento.unidadTiempoPeriodicidad = unidadTiempoPeriodicidad
            medicamento.presentacion = presentacion
            medicamento.fechaInicio = fechaInicio
            medicamento.fechaFin = fechaFin
            medicamento.duracion = duracion
            medicamento.formula = formula
            do {
                try moc.save()
            } catch {
                print(error)
                abort()
            }
            return medicamento
    }
    class func getText(medicamento: Medicamento?) -> String{
        return medicamento?.nombre ?? ""
    }
}
