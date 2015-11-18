//
//  Specification+CoreDataProperties.swift
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

extension Specification {

    @NSManaged var id: NSNumber?
    @NSManaged var text: String?

}
