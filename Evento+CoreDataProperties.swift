//
//  Evento+CoreDataProperties.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 12/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Evento {

    @NSManaged var cycle: NSNumber?
    @NSManaged var time: NSNumber?
    @NSManaged var type: NSNumber?
    @NSManaged var postponed: NSNumber?
    @NSManaged var state: NSNumber?
    @NSManaged var response: NSNumber?
    @NSManaged var responseTime: NSNumber?
    @NSManaged var medicamento: Medicamento?
    @NSManaged var notificationTime: NSNumber?
}
