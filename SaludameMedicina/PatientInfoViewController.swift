//
//  PatientInfoViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 13/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
import CoreData
class PatientInfoViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelIdentification: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelLastName: UILabel!
    
    var managedObjectContext: NSManagedObjectContext!
    let identificationTypeToast = NSLocalizedString("identificationTypeToast", tableName: "localization",
        comment: "Info about the identification type of the patient")
    let patientGenderToast = NSLocalizedString("patientGenderToast", tableName: "localization",
        comment: "Info about the gender of the patient")
    let birthDateToast = NSLocalizedString("birthDateToast", tableName: "localization",
        comment: "Info about the birth date of the patient")
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    @IBAction func showIdentificationTypeToast(sender: UIButton){
        showToast(patientGenderToast, sender: sender)
    }
    @IBAction func showBirthDateToast(sender: UIButton){
        showToast(birthDateToast, sender: sender)
    }
    @IBAction func showPatientGenderToast(sender: UIButton){
        showToast(identificationTypeToast, sender: sender)
    }
    var labelsMap = [UIView: UILabel]()
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
        initLabels()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    private func initLabels(){
        labelsMap = [textFieldIdentification: labelIdentification, textFieldName: labelName, textFieldLastName: labelLastName]
    }
    @IBOutlet weak var textFieldIdentification: UITextField!{
        didSet{
            textFieldIdentification?.delegate = self
            textFieldIdentification?.text = patient?.identification ?? ""
        }
    }
    @IBOutlet weak var textFieldName: UITextField!{
        didSet{
            textFieldName?.delegate = self
            textFieldName?.text = patient?.name ?? ""
        }
    }
    @IBOutlet weak var textFieldLastName: UITextField!{
        didSet{
            textFieldLastName?.delegate = self
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
        if let d = date{
            return TimeUtil.getDateFormatted(d)
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
            popover?.sourceView = sender
            popover?.permittedArrowDirections = [.Down]
            popover?.backgroundColor = UIColor.whiteColor()
            self.presentViewController(pickBirthDateViewController, animated: true, completion: nil)
        }
    }
    private func showToast(text: String, sender : UIView)
    {
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let toastViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.CustomToastViewId) as? CustomToastUIViewController)
        {
            
            toastViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            toastViewController.currentText = text
            let popover = toastViewController.popoverPresentationController
            popover?.delegate = self
            popover?.permittedArrowDirections = [.Up, .Down]
            popover?.sourceView = sender
            popover?.backgroundColor = UIColor.blackColor()
            self.presentViewController(toastViewController, animated: true, completion: nil)
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
            popover?.sourceView = sender
            popover?.backgroundColor = UIColor.whiteColor()
            self.presentViewController(pickDocumentTypePatientViewController, animated: true, completion: nil)
        }
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        let view = labelsMap[textField]
        let scrollPoint = CGPointMake(0, view?.frame.origin.y ?? 0 )
        scrollView?.setContentOffset(scrollPoint, animated: true)
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField{
        case textFieldIdentification:
            textFieldName?.becomeFirstResponder()
        case textFieldName:
            textFieldLastName?.becomeFirstResponder()
        default: break
        }
        return true
    }
}
