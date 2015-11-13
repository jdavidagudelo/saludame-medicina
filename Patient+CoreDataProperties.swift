//
//  Patient+CoreDataProperties.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 13/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Patient {

    @NSManaged var identificationType: String?
    @NSManaged var identification: String?
    @NSManaged var name: String?
    @NSManaged var lastName: String?
    @NSManaged var sex: String?
    @NSManaged var birthDate: NSDate?

}
