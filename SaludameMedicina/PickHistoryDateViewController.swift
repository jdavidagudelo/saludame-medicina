//
//  PickHistoryDateViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 26/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class PickHistoryDateViewController: UIViewController {
    
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
    @IBOutlet weak var datePicker: UIDatePicker!{
        didSet{
            datePicker.maximumDate = NSDate()
            datePicker?.date = date
        }
    }
    var date = NSDate(){
        didSet{
            datePicker?.date = date
        }
    }
    var saveDate: ((date: NSDate) -> Void)?
    @IBAction func cancel(sender: UIButton){
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func save(sender: UIButton){
        saveDate?(date: datePicker?.date ?? NSDate())
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
