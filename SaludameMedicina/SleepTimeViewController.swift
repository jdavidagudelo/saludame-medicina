//
//  SleepTimeViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 12/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class SleepTimeViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    @IBOutlet var wakeUpTimeLabel: UILabel!{
        didSet{
            wakeUpTimeLabel?.text = TimeUtil.getTimeFormatted(wakeUpTime ?? NSDate())
        }
    }
    @IBOutlet var sleepTimeLabel: UILabel!{
        didSet{
            sleepTimeLabel?.text = TimeUtil.getTimeFormatted(sleepTime ?? NSDate())
        }
    }
    func saveSleepTime(date: NSDate?){
        sleepTime = date
    }
    func saveWakeupTime(date: NSDate?){
        wakeUpTime = date
    }
    var sleepTime: NSDate?{
        get{
            if let dateString = NSUserDefaults.standardUserDefaults().objectForKey(SleepPreferences.GoToSleepTimePreferenceKey) as? String
            {
                let date = TimeUtil.getTimeFromString(dateString)
                return date
            }
            return NSDate()
        }
        
        set{
            sleepTimeLabel?.text = TimeUtil.getTimeFormatted(newValue ?? NSDate())
            if let date = newValue{
                let dateString = TimeUtil.getStringFromTime(date)
                NSUserDefaults.standardUserDefaults().setObject(dateString, forKey: SleepPreferences.GoToSleepTimePreferenceKey)
            }
        }
    }
    var wakeUpTime: NSDate?{
        get{
            if let dateString = NSUserDefaults.standardUserDefaults().objectForKey(SleepPreferences.WakeUpTimePreferenceKey) as? String
            {
                let date = TimeUtil.getTimeFromString(dateString)
                return date
            }
            return NSDate()
        }
        
        set{
            wakeUpTimeLabel?.text = TimeUtil.getTimeFormatted(newValue ?? NSDate())
            if let date = newValue{
                let dateString = TimeUtil.getStringFromTime(date)
                NSUserDefaults.standardUserDefaults().setObject(dateString, forKey: SleepPreferences.WakeUpTimePreferenceKey)
            }
        }
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    @IBAction func editSleepTime(sender: UIButton){
        showDatePicker(sender, preferenceKey: SleepPreferences.GoToSleepTimePreferenceKey, title: NSLocalizedString("goToSleepTimeTitle", tableName: "localization",
            comment: "Enter sleep time title"), date: sleepTime)
    }
    @IBAction func editWakeUpTime(sender: UIButton){
        showDatePicker(sender, preferenceKey: SleepPreferences.WakeUpTimePreferenceKey, title: NSLocalizedString("wakeUpTimeTitle", tableName: "localization",
            comment: "Enter wake up time title"), date: wakeUpTime)
    }
    func showDatePicker(sender: UIButton, preferenceKey: String, title: String, date: NSDate?)
    {
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let pickSleepTimeViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.PickSleepTimeId) as? PickSleepTimeViewController)
        {
            pickSleepTimeViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            pickSleepTimeViewController.date = date
            if preferenceKey == SleepPreferences.GoToSleepTimePreferenceKey{
                pickSleepTimeViewController.saveSleepTime = saveSleepTime
            }
            else{
                pickSleepTimeViewController.saveSleepTime = saveWakeupTime
            }
            pickSleepTimeViewController.titleText = title
            let popover = pickSleepTimeViewController.popoverPresentationController
            popover?.delegate = self
            popover?.sourceView = sender
            popover?.backgroundColor = UIColor.whiteColor()
            self.presentViewController(pickSleepTimeViewController, animated: true, completion: nil)
        }
    }
}
