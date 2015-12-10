//
//  CreateFormulaViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 5/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
import CoreData
class CreateFormulaViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    var formula: Formula?{
        didSet{
            textFieldDoctorName?.text = formula?.nombreMedico ?? ""
            textFieldInstitution?.text = formula?.institucion ?? ""
            textFieldNumberFormula?.text = formula?.numero ?? ""
            textViewRecommendations?.text = formula?.recomendaciones ?? ""
            date = formula?.fecha ?? NSDate()
        }
    }
    func textViewDidEndEditing(textView: UITextView) {
        textView.resignFirstResponder()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField{
        case textFieldInstitution:
            textFieldNumberFormula?.becomeFirstResponder()
        case textFieldNumberFormula:
            textFieldDoctorName?.becomeFirstResponder()
        default: break
        }
        return true
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
    @IBAction func showDateInfo(sender: UIButton){
        showToast(NSLocalizedString("dateFormulaHelp", tableName: "localization",
            comment: "Info about the date of a formula"), sender: sender)
    }
    @IBOutlet weak var textFieldInstitution: UITextField!{
        didSet{
            textFieldInstitution?.text = formula?.institucion
            textFieldInstitution?.delegate = self
        }
    }
    @IBOutlet weak var textFieldNumberFormula: UITextField!{
        didSet{
            textFieldNumberFormula?.text = formula?.numero
            textFieldNumberFormula?.delegate = self
        }
    }
    @IBOutlet weak var textFieldDoctorName: UITextField!
        {
        didSet{
            textFieldDoctorName?.text = formula?.nombreMedico
            textFieldDoctorName?.delegate = self
        }
    }
    @IBOutlet weak var textViewRecommendations: UITextView!{
        didSet{
            textViewRecommendations?.text = formula?.recomendaciones
            textViewRecommendations?.delegate = self
        }
    }
    @IBOutlet weak var labelInstitution: UILabel!
    @IBOutlet weak var labelNumberFormula: UILabel!
    var managedObjectContext: NSManagedObjectContext!
    @IBAction func cancel(sender: UIButton){
        navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func createFormula(sender : UIButton)
    {
        if (textFieldInstitution?.text?.isEmpty ?? false || textFieldInstitution?.text == nil ||
            textFieldNumberFormula?.text?.isEmpty ?? false || textFieldNumberFormula?.text == nil)
        {
            if (textFieldInstitution?.text?.isEmpty ?? false || textFieldInstitution?.text == nil){
                labelInstitution?.textColor = UIColor.redColor()
            }
            if (textFieldNumberFormula?.text?.isEmpty ?? false || textFieldNumberFormula?.text == nil){
                labelNumberFormula?.textColor = UIColor.redColor()
            }
            return
        }
        if(formula == nil)
        {
            Formula.createInManagedObjectContext(managedObjectContext, fecha: date, numero: textFieldNumberFormula?.text,
                recomendaciones: textViewRecommendations?.text, institucion: textFieldInstitution?.text, nombreMedico: textFieldDoctorName?.text)
        }
        else {
            formula?.institucion = textFieldInstitution?.text
            formula?.numero = textFieldNumberFormula?.text
            formula?.nombreMedico = textFieldDoctorName?.text
            formula?.recomendaciones = textViewRecommendations?.text
            formula?.fecha = date
            Formula.save(managedObjectContext )
        }
        navigationController?.popViewControllerAnimated(true)
    }
    @IBOutlet var labelDate: UILabel!{
        didSet{
            labelDate?.text = formattedDate
        }
    }
    var date: NSDate = NSDate(){
        didSet{
            labelDate?.text = formattedDate
        }
    }
    
    var formattedDate: String{
        get
        {
            return TimeUtil.getDateFormatted(date)
        }
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    @IBAction func showDatePicker(sender: UIButton)
    {
        performSegueWithIdentifier(SegueIdentifier.IdentifierPickDateFormula, sender: sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier
        {
            switch identifier
            {
            case SegueIdentifier.IdentifierPickDateFormula:
                if let tvc = segue.destinationViewController as? PickDateFormulaViewController
                {
                    tvc.date = date
                    tvc.createFormulaViewController = self
                    if let ppc = tvc.popoverPresentationController
                    {
                        ppc.delegate = self
                    }
                }
            default: break
            }
        }
    }

}
