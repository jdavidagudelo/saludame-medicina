//
//  Slot+CoreDataProperties.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 19/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Slot {

    @NSManaged var slot: NSNumber?
    @NSManaged var quantity: NSNumber?
    @NSManaged var medicamento: Medicamento?

}
