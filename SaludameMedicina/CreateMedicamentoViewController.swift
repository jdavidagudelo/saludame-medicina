//
//  CreateMedicamentoViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 10/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
import CoreData
@IBDesignable
class CreateMedicamentoViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    private struct SegueIdentifier{
        static let IdentifierPickFormulaMedicamento = "Pick Formula Medicamento"
        static let IdentifierPickUnitMedicamento = "Pick Interval Medicamento"
    }
    var medicamento: Medicamento? {
        didSet{
            formula = medicamento?.formula
            textViewRecommendations?.text = medicamento?.indicaciones
            if let periodicidad = medicamento?.periodicidad {
                textFieldPeriod?.text = "\(periodicidad)"
            }
            
            textFieldName?.text = medicamento?.nombre
            
            textFieldPresentation?.text = medicamento?.presentacion
            if let duracion = medicamento?.duracion{
                duration = Int(duracion)
                textFieldDuration?.text = "\(duracion)"
            }
            if let dosis = medicamento?.dosis{
                textFieldDose?.text = "\(dosis)"
            }
            periodUnit = medicamento?.unidadTiempoPeriodicidad
        }
    }
    
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var labelPeriod: UILabel!
    @IBOutlet weak var labelDose: UILabel!
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var textViewRecommendations: UITextView!{
        didSet{
            textViewRecommendations?.text = medicamento?.indicaciones
        }
    }
    
    @IBOutlet weak var textFieldPeriod: UITextField!{
        didSet{
            if let periodicidad = medicamento?.periodicidad{
                textFieldPeriod?.text = "\(periodicidad)"
            }
        }
    }
    
    @IBOutlet weak var textFieldName: UITextField!{
        didSet{
            textFieldName?.text = medicamento?.nombre
        }
    }
    
    @IBOutlet weak var textFieldPresentation: UITextField!{
        didSet{
            textFieldPresentation?.text = medicamento?.presentacion
        }
    }
    
    @IBOutlet weak var textFieldDuration: UITextField!{
        didSet{
            if let duracion = medicamento?.duracion{
                textFieldDuration?.text = "\(duracion)"
            }
        }
    }
    
    @IBOutlet weak var textFieldDose: UITextField!{
        didSet{
            if let dosis = medicamento?.dosis{
                textFieldDose?.text = "\(dosis)"
            }
        }
    }
    
    @IBOutlet weak var textFieldEndDate: UITextField!{
        didSet{
            textFieldEndDate?.text = getFormattedDate(endDate)
        }
    }
    @IBOutlet weak var textFieldStartDate : UITextField!{
        didSet{
            textFieldStartDate?.text = getFormattedDate(startDate)
        }
    }
    var duration = 0{
        didSet{
            textFieldEndDate?.text = getFormattedDate(endDate)
        }
    }
    @IBAction func durationUpdated(sender: UITextField){
        if let text = sender.text{
            if let d = Int(text)
            {
                duration = d
            }
        }
    }
    var endDate : NSDate{
        get{
            return NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: duration, toDate: startDate, options: NSCalendarOptions(rawValue: 0)) ?? NSDate()
        }
    }
    var startDate :NSDate{
        get{
            return formula?.fecha ?? NSDate()
        }
    }
    @IBOutlet weak var labelUnit: UILabel!{
        didSet{
            labelUnit?.text = periodUnit
        }
    }
    @IBOutlet weak var labelFormula: UILabel!{
        didSet{
            labelFormula?.text = Formula.getText(formula)
        }
    }
    
    @IBAction func cancel(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    private func validate() -> Bool{
        var valid = true
        if (textFieldName?.text?.isEmpty ?? false || textFieldName?.text == nil){
            labelName?.textColor = UIColor.redColor()
            valid = false
        }
        if (textFieldDose?.text?.isEmpty ?? false || textFieldDose?.text == nil){
            labelDose?.textColor = UIColor.redColor()
            valid = false
        }
        if (textFieldPeriod?.text?.isEmpty ?? false || textFieldPeriod?.text == nil){
            labelPeriod?.textColor = UIColor.redColor()
            valid = false
        }
        if (textFieldDuration?.text?.isEmpty ?? false || textFieldDuration?.text == nil){
            labelDuration?.textColor = UIColor.redColor()
            valid = false
        }
        return valid
    }
    
    @IBAction func save(sender: UIButton) {
        if !validate(){
            return
        }
        let periodicidad = Int((textFieldPeriod?.text)!)
        let dosis = Int((textFieldDose?.text)!)
        let unidadTiempoPeriodicidad = periodUnit
        var cantidad = 0.0
        if unidadTiempoPeriodicidad == IntervalConstants.HoursInterval {
            cantidad = Double(dosis ?? 0.0) * (24.0 / Double(periodicidad ?? 1.0)) * Double(duration)
        }
        else {
            cantidad = Double(dosis ?? 0.0) * (1.0 / Double(periodicidad ?? 1.0)) * Double(duration)
        }
        let indicaciones = textViewRecommendations?.text
        let nombre = textFieldName?.text
        let presentacion = textFieldPresentation?.text
        if medicamento == nil{
            medicamento = Medicamento.createInManagedObjectContext(managedObjectContext, cantidad: cantidad, periodicidad: periodicidad, dosis: dosis, concentracion: nil, indicaciones: indicaciones, via: nil, nombre: nombre, unidadTiempoPeriodicidad: unidadTiempoPeriodicidad, presentacion: presentacion, fechaInicio: startDate, fechaFin: endDate, duracion: duration, formula: formula)
        }
        else{
            medicamento?.cantidad = cantidad
            medicamento?.dosis = dosis
            medicamento?.indicaciones = indicaciones
            medicamento?.nombre = nombre
            medicamento?.duracion = duration
            medicamento?.periodicidad = periodicidad
            medicamento?.unidadTiempoPeriodicidad = unidadTiempoPeriodicidad
            medicamento?.presentacion = presentacion
            medicamento?.fechaFin = endDate
            medicamento?.fechaInicio = startDate
            medicamento?.formula = formula
            Medicamento.save(managedObjectContext)
        }
        navigationController?.popViewControllerAnimated(true)
    }
    var periodUnit: String?{
        didSet{
            labelUnit?.text = periodUnit
        }
    }
    var managedObjectContext: NSManagedObjectContext!
    var formula: Formula?{
        didSet{
            labelFormula?.text = Formula.getText(formula)
            textFieldStartDate?.text = getFormattedDate(startDate)
            textFieldEndDate?.text = getFormattedDate(endDate)
        }
    }
    private func initPeriodUnit(){
        periodUnit = IntervalConstants.HoursInterval
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        initPeriodUnit()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    private func getFormattedDate(date: NSDate) -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.stringFromDate(date)
    }
    private struct StoryBoard{
        static let CustomToastViewId = "CustomToastUIViewController"
    }
    @IBAction func showStartDateInfo(sender: UIButton){
        showToast(NSLocalizedString("startDateMedicationHelp", tableName: "localization",
            comment: "Info about the start date of a medication"), sender: sender)
    }
    @IBAction func showEndDateInfo(sender: UIButton){
        showToast(NSLocalizedString("endDateMedicationHelp", tableName: "localization",
            comment: "Info about the end date of a medication"), sender: sender)
    }
    @IBAction func showFormulaInfo(sender: UIButton){
        showToast(NSLocalizedString("selectFormulaMedicationHelp", tableName: "localization",
            comment: "Info about the formula of a medication"), sender: sender)
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier
        {
            switch identifier
            {
            case SegueIdentifier.IdentifierPickFormulaMedicamento:
                if let tvc = segue.destinationViewController as? PickFormulaMedicamentoViewController
                {
                    tvc.createMedicamentoController = self
                    tvc.formula = formula
                    if let ppc = tvc.popoverPresentationController
                    {
                        ppc.delegate = self
                    }
                }
                case SegueIdentifier.IdentifierPickUnitMedicamento:
                    if let tvc = segue.destinationViewController as? PickIntervalUnitMedicamentoViewController
                    {
                        tvc.createMedicamentoController = self
                        tvc.unit = periodUnit
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
