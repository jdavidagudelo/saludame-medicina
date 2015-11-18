//
//  PickFormulaMedicamentoViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 11/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
import CoreData
@IBDesignable
class PickFormulaMedicamentoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBInspectable
    var popoverHeight : CGFloat = CGFloat(200.0)
    @IBInspectable
    var formulaFont: UIFont!
    weak var createMedicamentoController : CreateMedicamentoViewController?
    
    var formula : Formula?{
        didSet{
            selectFormula(formula)
        }
    }
    private func selectFormula(formula : Formula?){
        if let f = formula
        {
            if let index = formulas.indexOf(f) {
                pickerFormulas?.selectRow(index+1, inComponent: 0, animated: true)
            }
        }
        else{
            pickerFormulas?.selectRow(0, inComponent: 0, animated: true)
        }
    }
    var formulas = [Formula](){
        didSet{
            pickerFormulas?.reloadAllComponents()
            selectFormula(formula)
        }
    }
    @IBOutlet
    weak var pickerFormulas : UIPickerView!{
        didSet{
            pickerFormulas?.dataSource = self
            pickerFormulas?.delegate = self
            selectFormula(formula)
        }
    }
    @IBAction func cancel(sender: UIButton){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        fetchFormulas()
        // Do any additional setup after loading the view.
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    private func getFormulaText(formula: Formula?) -> String{
      return Formula.getText(formula)
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if row == 0{
            return Formula.getText(nil)
        }
        return getFormulaText(formulas[row-1])
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return formulas.count+1
    }
    
    private func fetchFormulas(){
        let fetchRequest = NSFetchRequest(entityName: "Formula")
        do{
            if let fetchResults = try managedObjectContext!.executeFetchRequest(fetchRequest) as? [Formula] {
                formulas = fetchResults
            }
        }
        catch {
            print(error)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveFormula(sender: UIButton){
        let index = pickerFormulas.selectedRowInComponent(0)
        if index == 0{
            createMedicamentoController?.formula = nil
        }
        else{
            createMedicamentoController?.formula = formulas[index-1]
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        var text = ""
        if row == 0{
            text = Formula.getText(nil)
        }
        else
        {
            text = getFormulaText(formulas[row-1])
        }
        let label = UILabel()
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        label.text = text
        return label
    }
    override var preferredContentSize: CGSize {
        get{
            if  presentingViewController != nil {
                return CGSize(width: super.preferredContentSize.width, height: popoverHeight)
            }
            else{
                return super.preferredContentSize
            }
        }
        set{super.preferredContentSize = newValue}
    }
    

}
