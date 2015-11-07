//
//  PickDateFormulaViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 5/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class PickDateFormulaViewController: UIViewController {
    @IBOutlet var containerView: UIView!
    @IBOutlet var datePicker: UIDatePicker!{
        didSet{
            if date != nil{
                datePicker?.date = date!
            }
        }
    }
    var createFormulaViewController : CreateFormulaViewController?
    var date: NSDate? = NSDate(){
        didSet{
            if date != nil{
                datePicker?.date = date!
            }
        }
    }
    @IBAction func save(sender: UIButton)
    {
        date = datePicker?.date
        if let currentDate = date
        {
            createFormulaViewController?.date = currentDate
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancel(sender: UIButton)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker?.datePickerMode = UIDatePickerMode.Date
        datePicker?.maximumDate = NSDate()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
