//
//  NotificationMedicationViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 17/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
import CoreData
class NotificationMedicationViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    struct SegueIdentifier{
        static let IdentifierPickDelayInterval = "Show Delay Interval Picker"
        static let IdentifierPickLostDoseCause = "Show Lost Dose Picker"
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let pickDelayIntervalViewController = segue.destinationViewController as? PickDelayIntervalViewController{
            if segue.identifier == SegueIdentifier.IdentifierPickDelayInterval{
                pickDelayIntervalViewController.changeInterval = changeInterval
                let popover = pickDelayIntervalViewController.popoverPresentationController
                popover?.delegate = self
            }
        }
        if let pickLostDoseCauseViewController = segue.destinationViewController as? PickLostDoseCauseViewController{
            if segue.identifier == SegueIdentifier.IdentifierPickLostDoseCause{
                pickLostDoseCauseViewController.cancelEvent = cancelEvent
                let popover = pickLostDoseCauseViewController.popoverPresentationController
                popover?.delegate = self
            }
        }
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
                if referenceName?.parameterId == PatientNameParameter.Nickname{
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
    private func changeInterval(){
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    private func cancelEvent(){
        Evento.setAnswer(managedObjectContext, event: event, answer: EventAnswer.Rejected)
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func accept(sender: UIButton){
        Evento.setAnswer(managedObjectContext, event: event, answer: EventAnswer.Accepted)
        DoseInventory.consumeDose(managedObjectContext, medicamento: event?.medicamento)
        dismissViewControllerAnimated(true, completion: nil)
    }
}
