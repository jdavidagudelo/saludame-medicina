//
//  Formula+CoreDataProperties.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 30/10/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Formula {

    @NSManaged var numero: String?
    @NSManaged var institucion: String?
    @NSManaged var fecha: NSDate?
    @NSManaged var recomendaciones: String?
    @NSManaged var nombreMedico: String?
}
