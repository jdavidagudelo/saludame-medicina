//
//  Appointment+CoreDataProperties.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 26/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Appointment {

    @NSManaged var doctorName: String?
    @NSManaged var place: String?
    @NSManaged var date: NSDate?
    @NSManaged var descriptionText: String?

}
