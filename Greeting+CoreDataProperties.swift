//
//  Greeting+CoreDataProperties.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 18/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Greeting {

    @NSManaged var id: NSNumber?
    @NSManaged var genreId: NSNumber?
    @NSManaged var hourId: NSNumber?
    @NSManaged var message: String?
    @NSManaged var protocolId: NSNumber?
    @NSManaged var referenceName: ReferenceNamePatient?

}
