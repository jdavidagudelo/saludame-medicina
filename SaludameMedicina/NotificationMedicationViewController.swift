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
   
    var cancelled: Bool = false
    @IBInspectable var notificationTimeSeconds = 60
    let dosePrefix = NSLocalizedString("dosePrefix", tableName: "localization",
        comment: "The dose prefix")
    let patientDefaultName = NSLocalizedString("patientDefaultName", tableName: "localization",
        comment: "The patient default name")
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    private var currentIndex = 0
    @IBOutlet var labelMessage: UILabel!{
        didSet{
            labelMessage.text = "\(getGreeting() ?? "") \(getSpecification() ?? "")"
        }
    }
    @IBOutlet var labelQuantity: UILabel!{
        didSet{
            labelQuantity?.text = "\(dosePrefix)\(event?.medicamento?.dosis ?? 0)"
        }
    }
    var managedObjectContext: NSManagedObjectContext!{
        didSet{
            labelMessage.text = "\(getGreeting() ?? "") \(getSpecification() ?? "")"
            if let e = eventId{
                if let id = managedObjectContext?.persistentStoreCoordinator?.managedObjectIDForURIRepresentation(e)
                {
                    events = Evento.getEventsSameDate(managedObjectContext, id: id)
                    
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
                    events = Evento.getEventsSameDate(managedObjectContext, id: id)
                }
            }
        }
    }
    var events = [Evento](){
        didSet{
            if currentIndex < events.count{
                event = events[currentIndex]
            }
        }
    }
    var event : Evento?{
        didSet{
            labelMedication?.text = event?.medicamento?.nombre
            labelQuantity?.text = "\(dosePrefix)\(event?.medicamento?.dosis ?? 0)"
            cancelled = false
            let time: Int64 = Int64(UInt64(notificationTimeSeconds) * NSEC_PER_SEC)
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, time), dispatch_get_main_queue()){
                if !self.cancelled{
                    self.lostNotification()
                }
           }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        Medicamento.validateMedicationEnded(managedObjectContext, medicamento: event?.medicamento)
        Notifier.updateNotifications(managedObjectContext)
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
                if referenceName?.parameterId == PatientNameParameter.Nickname{
                    if let nickname = NSUserDefaults.standardUserDefaults().objectForKey(NotificationPreferences.NicknamePreferenceKey) as? String
                    {
                        patientName = "\(patientName) \(nickname)"
                    }
                    else{
                        patientName = "\(patientName) \(patientDefaultName)"
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
    private func lostNotification(){
        if event?.type == EventType.Medication{
            Evento.setAnswer(managedObjectContext, event: event, answer: EventAnswer.Notified)
            Evento.updateNextEvent(managedObjectContext, event: event)
            Notifier.updateNotifications(managedObjectContext)
            currentIndex++
            cancelled = true
            if currentIndex < events.count{
                event = events[currentIndex]
            }
            else{
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    private func changeInterval(minutes: Int){
        Evento.setAnswer(managedObjectContext, event: event, answer: EventAnswer.Delayed)
        Evento.updateNextEvent(managedObjectContext, event: event)
        Evento.delayEvent(managedObjectContext, minutes: minutes, event: event)
        Notifier.updateNotifications(managedObjectContext)
        currentIndex++
        cancelled = true
        if currentIndex < events.count{
            event = events[currentIndex]
        }
        else{
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    private func cancelEvent(){
        Evento.setAnswer(managedObjectContext, event: event, answer: EventAnswer.Rejected)
        Evento.updateNextEvent(managedObjectContext, event: event)
        Notifier.updateNotifications(managedObjectContext)
        currentIndex++
        cancelled = true
        if currentIndex < events.count{
            event = events[currentIndex]
        }
        else{
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    @IBAction func accept(sender: UIButton){
        Evento.setAnswer(managedObjectContext, event: event, answer: EventAnswer.Accepted)
        Evento.updateNextEvent(managedObjectContext, event: event)
        DoseInventory.consumeDose(managedObjectContext, medicamento: event?.medicamento)
        Notifier.updateNotifications(managedObjectContext)
        currentIndex++
        cancelled = true
        if currentIndex < events.count{
            event = events[currentIndex]
        }
        else{
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    @IBAction func showDoseLostCausePicker(sender : UIButton)
    {
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let pickLostDoseCauseViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.PickLostDoseCauseViewId) as? PickLostDoseCauseViewController)
        {
            pickLostDoseCauseViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            pickLostDoseCauseViewController.cancelEvent = cancelEvent
            let popover = pickLostDoseCauseViewController.popoverPresentationController
            popover?.delegate = self
            popover?.permittedArrowDirections = [.Up, .Down]
            popover?.sourceView = sender
            popover?.sourceRect = sender.bounds
            self.presentViewController(pickLostDoseCauseViewController, animated: true, completion: nil)
        }
    }
    @IBAction func showDelayPicker(sender : UIButton)
    {
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let pickDelayIntervalViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.PickDelayIntervalViewId) as? PickDelayIntervalViewController)
        {
            pickDelayIntervalViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            pickDelayIntervalViewController.changeInterval = changeInterval
            let popover = pickDelayIntervalViewController.popoverPresentationController
            popover?.delegate = self
            popover?.permittedArrowDirections = [.Up, .Down]
            popover?.sourceView = sender
            popover?.sourceRect = sender.bounds
            self.presentViewController(pickDelayIntervalViewController, animated: true, completion: nil)
        }
    }
}
