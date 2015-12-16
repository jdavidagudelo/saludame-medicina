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
class CreateMedicamentoViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var labelsMap = [UIView: UILabel]()
    var medicamento: Medicamento? {
        didSet{
            formula = medicamento?.formula
            textFieldRecommendations?.text = medicamento?.indicaciones
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
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        let view = labelsMap[textField]
        let scrollPoint = CGPointMake(0, view?.frame.origin.y ?? 0)
        scrollView?.setContentOffset(scrollPoint, animated: true)
        return true
    }
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var labelPeriod: UILabel!
    @IBOutlet weak var labelDose: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPresentation: UILabel!
    @IBOutlet weak var labelRecommendations: UILabel!
    @IBOutlet weak var textFieldRecommendations: UITextField!{
        didSet{
            textFieldRecommendations?.text = medicamento?.indicaciones
            textFieldRecommendations?.delegate = self
            
        }
    }
    
    @IBOutlet weak var textFieldPeriod: UITextField!{
        didSet{
            textFieldPeriod?.delegate = self
            if let periodicidad = medicamento?.periodicidad{
                textFieldPeriod?.text = "\(periodicidad)"
            }
        }
    }
    
    @IBOutlet weak var textFieldName: UITextField!{
        didSet{
            textFieldName?.text = medicamento?.nombre
            textFieldName?.delegate = self
        }
    }
    
    @IBOutlet weak var textFieldPresentation: UITextField!{
        didSet{
            textFieldPresentation?.text = medicamento?.presentacion
            textFieldPresentation?.delegate = self
        }
    }
    
    @IBOutlet weak var textFieldDuration: UITextField!{
        didSet{
            
            if let duracion = medicamento?.duracion{
                textFieldDuration?.text = "\(duracion)"
            }
            textFieldDuration?.delegate = self
        }
    }
    
    @IBOutlet weak var textFieldDose: UITextField!{
        didSet{
            if let dosis = medicamento?.dosis{
                textFieldDose?.text = "\(dosis)"
            }
            textFieldDose?.delegate = self
        }
    }
    
    @IBOutlet weak var textFieldEndDate: UITextField!{
        didSet{
            textFieldEndDate?.text = getFormattedDate(endDate)
            textFieldEndDate?.delegate = self
        }
    }
    @IBOutlet weak var textFieldStartDate : UITextField!{
        didSet{
            textFieldStartDate?.text = getFormattedDate(startDate)
            textFieldStartDate?.delegate = self
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
        let indicaciones = textFieldRecommendations?.text
        let nombre = textFieldName?.text
        let presentacion = textFieldPresentation?.text
        if medicamento == nil{
            medicamento = Medicamento.createInManagedObjectContext(managedObjectContext, cantidad: cantidad, periodicidad: periodicidad, dosis: dosis, concentracion: nil, indicaciones: indicaciones, via: nil, nombre: nombre, unidadTiempoPeriodicidad: unidadTiempoPeriodicidad, presentacion: presentacion, fechaInicio: startDate, fechaFin: endDate, duracion: duration, formula: formula)
            DoseInventory.createInManagedObjectContext(managedObjectContext, medicamento: medicamento, currentAmount: medicamento?.cantidad, consumedAmount: 0)
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
            let doseInventory = DoseInventory.getDoseInventory(managedObjectContext, medicamento: medicamento)
            doseInventory?.currentAmount = Int(medicamento?.cantidad ?? 0) - Int(doseInventory?.consumedAmount ?? 0)
            DoseInventory.save(managedObjectContext)
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
        if periodUnit == nil{
            periodUnit = IntervalConstants.HoursInterval
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        initPeriodUnit()
        initLabelsMap()
        // Do any additional setup after loading the view.
    }
    private func initLabelsMap(){
        labelsMap = [textFieldName: labelName, textFieldPresentation: labelPresentation, textFieldDose: labelDose,
            textFieldPeriod: labelPeriod, textFieldDuration: labelDuration, textFieldRecommendations: labelRecommendations]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    private func getFormattedDate(date: NSDate) -> String{
        return TimeUtil.getDateFormatted(date)
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
    @IBAction func showFormulaPicker(sender : UIButton)
    {
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let pickFormulaMedicamentoViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.PickFormulaMedicamentoViewId) as? PickFormulaMedicamentoViewController)
        {
            
            pickFormulaMedicamentoViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            pickFormulaMedicamentoViewController.formula = formula
            pickFormulaMedicamentoViewController.createMedicamentoController = self
            let popover = pickFormulaMedicamentoViewController.popoverPresentationController
            popover?.delegate = self
            popover?.sourceView = sender
            self.presentViewController(pickFormulaMedicamentoViewController, animated: true, completion: nil)
        }
    }
    @IBAction func showIntervalUnitPicker(sender : UIButton)
    {
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let pickIntervalUnitViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.PickUnitMedicamentoViewId) as? PickIntervalUnitMedicamentoViewController)
        {
            
            pickIntervalUnitViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            pickIntervalUnitViewController.unit = periodUnit
            pickIntervalUnitViewController.createMedicamentoController = self
            let popover = pickIntervalUnitViewController.popoverPresentationController
            popover?.delegate = self
            popover?.sourceView = sender
            self.presentViewController(pickIntervalUnitViewController, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField{
            case textFieldName:
                textFieldPresentation?.becomeFirstResponder()
            case textFieldPresentation:
                textFieldDose?.becomeFirstResponder()
            case textFieldDose:
                textFieldPeriod?.becomeFirstResponder()
            case textFieldPeriod:
                textFieldDuration?.becomeFirstResponder()
            case textFieldDuration:
                textFieldRecommendations?.becomeFirstResponder()
            case textFieldRecommendations:
                fallthrough
            default: break
        }
        return true
    }
}
