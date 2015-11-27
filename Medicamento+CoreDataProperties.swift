//
//  Medicamento+CoreDataProperties.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 10/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Medicamento {

    @NSManaged var cantidad: NSNumber?
    @NSManaged var periodicidad: NSNumber?
    @NSManaged var dosis: NSNumber?
    @NSManaged var concentracion: NSNumber?
    @NSManaged var indicaciones: String?
    @NSManaged var via: String?
    @NSManaged var nombre: String?
    @NSManaged var unidadTiempoPeriodicidad: String?
    @NSManaged var presentacion: String?
    @NSManaged var fechaInicio: NSDate?
    @NSManaged var fechaFin: NSDate?
    @NSManaged var duracion: NSNumber?
    @NSManaged var formula: Formula?
    

}
