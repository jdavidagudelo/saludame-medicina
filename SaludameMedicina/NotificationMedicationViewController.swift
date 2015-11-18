//
//  NotificationMedicationViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 17/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
import CoreData
class NotificationMedicationViewController: UIViewController {
    @IBOutlet var labelMessage: UILabel!{
        didSet{
            labelMessage.text = "\(getGreeting() ?? "") \(getSpecification() ?? "")"
        }
    }
    @IBOutlet var labelQuantity: UILabel!{
        didSet{
            labelQuantity?.text = "Dosis: \(event?.medicamento?.dosis ?? 0)"
        }
    }
    var managedObjectContext: NSManagedObjectContext!{
        didSet{
            labelMessage.text = "\(getGreeting() ?? "") \(getSpecification() ?? "")"
            if let e = eventId{
                if let id = managedObjectContext?.persistentStoreCoordinator?.managedObjectIDForURIRepresentation(e)
                {
                    event = Evento.getEventById(managedObjectContext, id: id)
                    labelQuantity?.text = "Dosis: \(event?.medicamento?.dosis ?? 0)"
                    
                }
            }
        }
    }
    @IBOutlet weak var labelMedication: UILabel!{
        didSet{
            labelMedication?.text = event?.medicamento?.nombre
        }
    }
    var eventId: NSURL?{
        didSet{
            if let e = eventId{
                if let id = managedObjectContext?.persistentStoreCoordinator?.managedObjectIDForURIRepresentation(e)
                {
                    event = Evento.getEventById(managedObjectContext, id: id)
                }
            }
        }
    }
    var event : Evento?{
        didSet{
            labelMedication?.text = event?.medicamento?.nombre
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func getSpecification() -> String?
    {
        if managedObjectContext != nil{
            var specification : String? = ""
            if let specifications = Specification.getAll(managedObjectContext){
                let k = Int(arc4random_uniform(UInt32(specifications.count)))
                if  !(specifications.isEmpty ?? false){
                    specification = specifications[k].text
                }
            }
            return specification
        }
        return ""
    }
    private func getGreeting() -> String?
    {
        if managedObjectContext != nil{
            let patient = Patient.getPatient(managedObjectContext)
            var gender: NSNumber!
            if patient?.sex == Genre.Male{
                gender = GenreId.Male
            }
            else if patient?.sex == Genre.Female{
                gender = GenreId.Female
            }
            else{
                gender = GenreId.Both
            }
            let protocolId = (NSUserDefaults.standardUserDefaults().objectForKey(NotificationPreferences.ProtocolPreferenceKey) as? NSNumber) ?? Protocol.Formal
            let hourId = TimeUtil.getDayTime()
            var patientName : String! = ""
            var result : String! = ""
            let greetings = Greeting.getFilteredGreetings(managedObjectContext, protocolId: protocolId!, hourId: hourId, genreId: gender) ?? []
            if !greetings.isEmpty{
                let k = Int(arc4random_uniform(UInt32(greetings.count)))
                result = greetings[k].message ?? ""
                let referenceName = greetings[k].referenceName
                let prefix = referenceName?.prefix
                let name = patient?.name ?? ""
                let completeName : String! = "\(patient?.name ?? "") \(patient?.lastName ?? "")"
                if prefix?.id == 6{
                    patientName = ""
                }
                else if referenceName?.parameterId == PatientNameParameter.Nickname{
                    if let nickname = NSUserDefaults.standardUserDefaults().objectForKey(NotificationPreferences.NicknamePreferenceKey) as? String
                    {
                        patientName = "\(patientName) \(nickname)"
                    }
                    else{
                        patientName = "\(patientName) Paciente"
                    }
                }
                else if referenceName?.parameterId == PatientNameParameter.Names
                {
                    patientName = "\(patientName) \(name)"
                }
                else if referenceName?.parameterId == PatientNameParameter.LastNames{
                    patientName = "\(patientName) \(completeName)"
                }
            }
            return result?.stringByReplacingOccurrencesOfString("$", withString: patientName)
        }
        return ""
    }
}
