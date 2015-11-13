//
//  Patient.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 13/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import Foundation
import CoreData


class Patient: NSManagedObject {
    class func delete(moc: NSManagedObjectContext, patient: Patient){
        do {
            moc.deleteObject(patient)
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
    class func getAll(moc: NSManagedObjectContext) -> [Patient]?
    {
        let fetchRequest = NSFetchRequest(entityName: "Patient")
        do{
            return try moc.executeFetchRequest(fetchRequest) as? [Patient]
        }
        catch{
            return []
        }
    }
    class func createInManagedObjectContext(moc: NSManagedObjectContext,
        identificationType: String?,
        identification: String?,
        name: String?,
        lastName: String?,
        sex: String?,
        birthDate: NSDate?) -> Patient {
        
            let patient = NSEntityDescription.insertNewObjectForEntityForName("Patient", inManagedObjectContext: moc) as! Patient
            patient.identificationType = identificationType
            patient.identification = identification
            patient.name = name
            patient.lastName = lastName
            patient.sex = sex
            patient.birthDate = birthDate
            do {
                try moc.save()
            } catch {
                print(error)
                abort()
            }
            return patient
    }
   

}
