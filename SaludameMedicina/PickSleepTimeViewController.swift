//
//  PickSleepTimeViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 12/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class PickSleepTimeViewController: UIViewController {
    
    var sleepTimeViewController : SleepTimeViewController?
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
    
    var currentKey = SleepPreferences.GoToSleepTimePreferenceKey
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
        
        if currentKey == SleepPreferences.GoToSleepTimePreferenceKey && date != nil
        {
            sleepTimeViewController?.sleepTime = date
        }
        else if currentKey == SleepPreferences.WakeUpTimePreferenceKey
        {
            sleepTimeViewController?.wakeUpTime = date
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
