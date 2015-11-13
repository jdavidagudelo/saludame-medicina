//
//  PickBirthDateViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 13/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class PickBirthDateViewController: UIViewController {
    var patientInfoViewController : PatientInfoViewController?
    var date: NSDate?{
        didSet{
            datePicker?.date = date ?? NSDate()
        }
    }
    @IBOutlet weak var datePicker: UIDatePicker!{
        didSet{
            datePicker?.date = date ?? NSDate()
        }
    }
    @IBAction func cancel(sendet: UIButton){
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func save(sender: UIButton){
        date = datePicker?.date
        patientInfoViewController?.birthDate = date
        dismissViewControllerAnimated(true, completion: nil)
    }
}
