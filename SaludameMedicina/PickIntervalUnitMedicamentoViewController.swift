//
//  PickIntervalUnitMedicamentoViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 11/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
@IBDesignable
class PickIntervalUnitMedicamentoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var createMedicamentoController: CreateMedicamentoViewController?
    @IBInspectable
    var popoverHeight : CGFloat = CGFloat(200.0)
    var unit :String?{
        didSet{
           selectUnit(unit)
        }
    }
    private func selectUnit(unit: String?){
        if let u = unit{
            if let index = intervals.indexOf(u)
            {
                pickerInterval?.selectRow(index, inComponent: 0, animated: true)
            }
        }
    }
    var intervals = [String](){
        didSet{
            pickerInterval?.reloadAllComponents()
            selectUnit(unit)
        }
    }
    @IBOutlet
    weak var pickerInterval: UIPickerView!{
        didSet{
            pickerInterval?.dataSource = self
            pickerInterval?.delegate = self
            
        }
    }
    private func initIntervals(){
        intervals = [IntervalConstants.HoursInterval, IntervalConstants.DaysInterval]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initIntervals()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return intervals.count
    }
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        let text = intervals[row]
        let label = UILabel()
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        label.text = text
        return label
    }
    @IBAction func cancel(sender: UIButton){
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func saveInterval(sender: UIButton){
        let unit = intervals[pickerInterval.selectedRowInComponent(0)]
        createMedicamentoController?.periodUnit = unit
        dismissViewControllerAnimated(true, completion: nil)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
