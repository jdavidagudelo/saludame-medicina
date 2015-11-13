//
//  PickStartTimeScheduleViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 13/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class PickStartTimeScheduleViewController: UIViewController {
    
    var scheduleMedicationViewController : ScheduleMedicationViewController?
    var date: NSDate?{
        didSet{
            timePicker?.date = date ?? NSDate()
        }
    }
    @IBOutlet weak var timePicker: UIDatePicker!{
        didSet{
            timePicker?.date = date ?? NSDate()
        }
    }
    @IBAction func cancel(sendet: UIButton){
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func save(sender: UIButton){
        date = timePicker?.date
        scheduleMedicationViewController?.startTime = date
        dismissViewControllerAnimated(true, completion: nil)
    }
}
