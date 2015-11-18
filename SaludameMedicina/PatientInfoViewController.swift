//
//  PatientInfoViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 13/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
import CoreData
class PatientInfoViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext!
    
    private struct StoryBoard{
        static let PickBirthDateViewId = "PickBirthDateViewController"
        static let PickDocumentTypeViewId = "PickDocumentTypePatientViewController"
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    var patient: Patient?{
        didSet{
            birthDate = patient?.birthDate
            identificationType = patient?.identificationType
            textFieldLastName?.text = patient?.lastName ?? ""
            textFieldIdentification?.text = patient?.identification ?? ""
            textFieldName?.text = patient?.name ?? ""
            labelIdentificationType?.text = patient?.identificationType ?? ""
            labelBirthDate?.text = formattedDate(patient?.birthDate)
            switchFemale?.on = patient?.sex == Genre.Female
            switchMale?.on = patient?.sex == Genre.Male
        }
    }
    var selectedSex : String?{
        get{
            var sex : String! = ""
            if let on = switchFemale?.on{
                if on{
                    sex = Genre.Female
                }
            }
            if let on = switchMale?.on{
                if on{
                    sex = Genre.Male
                }
            }
            return sex
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        patient = Patient.getPatient(managedObjectContext)
    }
    @IBOutlet weak var textFieldIdentification: UITextField!{
        didSet{
            textFieldIdentification?.text = patient?.identification ?? ""
        }
    }
    @IBOutlet weak var textFieldName: UITextField!{
        didSet{
            textFieldName?.text = patient?.name ?? ""
        }
    }
    @IBOutlet weak var textFieldLastName: UITextField!{
        didSet{
            textFieldLastName?.text = patient?.lastName ?? ""
        }
    }
    @IBOutlet weak var switchMale: UISwitch!{
        didSet{
            switchMale?.on = patient?.sex == Genre.Male
        }
    }
    @IBOutlet weak var switchFemale: UISwitch!{
        didSet{
            switchFemale?.on = patient?.sex == Genre.Female
        }
    }
    @IBOutlet weak var labelIdentificationType: UILabel!{
        didSet{
            labelIdentificationType?.text = patient?.identificationType ?? ""
        }
    }
    var birthDate : NSDate?{
        didSet{
            patient?.birthDate = birthDate
            labelBirthDate?.text = formattedDate(birthDate)
        }
    }
    private func formattedDate(date: NSDate?) -> String?{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        if let d = date{
            return formatter.stringFromDate(d)
        }
        return ""
    }
    @IBOutlet weak var labelBirthDate: UILabel!{
        didSet{
            labelBirthDate?.text = formattedDate(patient?.birthDate)
        }
    }
    var identificationType: String?{
        didSet{
            patient?.identificationType = identificationType
            labelIdentificationType?.text = identificationType
        }
    }
    @IBAction func updateSwitchGenreMale(sender: UISwitch){
        if !(switchMale?.on ?? true){
            switchMale?.on = true
        }
        switchFemale?.on = false
    }
    @IBAction func updateSwitchGenreFemale(sender: UISwitch){
        if !(switchFemale?.on ?? true){
            switchFemale?.on = true
        }
        switchMale?.on = false
    }
    @IBAction func showPickDate(sender: UIButton){
        showDatePicker(sender , date: patient?.birthDate ?? NSDate())
    }
    @IBAction func showPickDocumenType(sender: UIButton){
        showDocumentTypePicker(sender , documentType: patient?.identificationType ?? "")
    }
    @IBAction func save(sender: UIButton){
        if patient == nil{
           
            Patient.createInManagedObjectContext(managedObjectContext, identificationType: identificationType, identification: textFieldIdentification?.text, name: textFieldName?.text, lastName: textFieldLastName?.text, sex: selectedSex, birthDate: birthDate)
        }else{
            patient?.identificationType = identificationType
            patient?.identification = textFieldIdentification?.text
            patient?.name = textFieldName?.text
            patient?.lastName = textFieldLastName?.text
            patient?.sex = selectedSex
            patient?.birthDate = birthDate
            Patient.save(managedObjectContext)
        }
        navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func cancel(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    func showDatePicker(sender: UIButton, date: NSDate?)
    {
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let pickBirthDateViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.PickBirthDateViewId) as? PickBirthDateViewController)
        {
            pickBirthDateViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            pickBirthDateViewController.date = date
            
            pickBirthDateViewController.patientInfoViewController = self
            let popover = pickBirthDateViewController.popoverPresentationController
            popover?.delegate = self
            popover?.permittedArrowDirections = [.Up, .Down]
            popover?.sourceView = sender
            popover?.sourceRect = sender.bounds
            self.presentViewController(pickBirthDateViewController, animated: true, completion: nil)
        }
    }
    func showDocumentTypePicker(sender: UIButton, documentType: String?)
    {
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let pickDocumentTypePatientViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.PickDocumentTypeViewId) as? PickDocumentTypePatientViewController)
        {
            pickDocumentTypePatientViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            pickDocumentTypePatientViewController.documentType = documentType
            pickDocumentTypePatientViewController.patientInfoViewController = self
            let popover = pickDocumentTypePatientViewController.popoverPresentationController
            popover?.delegate = self
            popover?.permittedArrowDirections = [.Up, .Down]
            popover?.sourceView = sender
            popover?.sourceRect = sender.bounds
            self.presentViewController(pickDocumentTypePatientViewController, animated: true, completion: nil)
        }
    }
}