//
//  PickAppointmentDateViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 26/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class PickAppointmentDateViewController: UIViewController {
    var saveDate: ((date: NSDate) -> Void)?
    var date = NSDate(){
        didSet{
            datePicker?.date = date
        }
    }
    @IBOutlet weak var datePicker: UIDatePicker!{
        didSet{
            datePicker?.datePickerMode = datePickerMode
            datePicker.minimumDate = NSDate()
            datePicker?.date = date
        }
    }
    var titleText: String?{
        didSet{
            labelTitle?.text = titleText
        }
    }
    @IBOutlet weak var labelTitle: UILabel!{
        didSet{
            labelTitle?.text = titleText
        }
    }
    var datePickerMode =  UIDatePickerMode.Date{
        didSet{
            datePicker?.datePickerMode = datePickerMode
        }
    }
    @IBAction func save(sender: UIButton){
        saveDate?(date : datePicker.date)
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancel(sender: UIButton)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
