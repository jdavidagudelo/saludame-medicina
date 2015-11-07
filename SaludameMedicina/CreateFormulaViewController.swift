//
//  CreateFormulaViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 5/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
import CoreData
class CreateFormulaViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    var formula: Formula?{
        didSet{
            textFieldDoctorName?.text = formula?.nombreMedico ?? ""
            textFieldInstitution?.text = formula?.institucion ?? ""
            textFieldNumberFormula?.text = formula?.numero ?? ""
            textViewRecommendations?.text = formula?.recomendaciones ?? ""
            date = formula?.fecha ?? NSDate()
        }
    }
    @IBOutlet weak var textFieldInstitution: UITextField!{
        didSet{
            textFieldInstitution?.text = formula?.institucion
        }
    }
    @IBOutlet weak var textFieldNumberFormula: UITextField!{
        didSet{
            textFieldNumberFormula?.text = formula?.numero
        }
    }
    @IBOutlet weak var textFieldDoctorName: UITextField!
        {
        didSet{
            textFieldDoctorName?.text = formula?.nombreMedico
        }
    }
    @IBOutlet weak var textViewRecommendations: UITextView!{
        didSet{
            textViewRecommendations?.text = formula?.recomendaciones
        }
    }
    @IBOutlet weak var labelInstitution: UILabel!
    @IBOutlet weak var labelNumberFormula: UILabel!
    var managedObjectContext: NSManagedObjectContext!
    private struct SegueIdentifier{
        static let IdentifierPickDateFormula = "Pick Formula Date"
        static let IdentifierBackToFormulaList = "Back To Formula List"
    }
    @IBAction func cancel(sender: UIButton){
        navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func createFormula(sender : UIButton)
    {
        if (textFieldInstitution?.text?.isEmpty ?? false || textFieldInstitution?.text == nil ||
            textFieldNumberFormula.text?.isEmpty ?? false || textFieldNumberFormula?.text == nil)
        {
            if (textFieldInstitution?.text?.isEmpty ?? false || textFieldInstitution?.text == nil){
                labelInstitution?.textColor = UIColor.redColor()
            }
            if (textFieldNumberFormula.text?.isEmpty ?? false || textFieldNumberFormula?.text == nil){
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
        //performSegueWithIdentifier(SegueIdentifier.IdentifierBackToFormulaList, sender: sender)
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
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd-M-yyyy"
            return formatter.stringFromDate(date)
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
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
