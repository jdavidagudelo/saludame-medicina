//
//  SleepTimeViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 12/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class SleepTimeViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    var df = NSDateFormatter()
    var sleepTime: NSDate?{
        get{
            df.dateFormat = "hh:mm a"
            if let dateString = NSUserDefaults.standardUserDefaults().objectForKey(SleepPreferences.GoToSleepTimePreferenceKey) as? String
            {
                let date = df.dateFromString(dateString)
                return date
            }
            return NSDate()
        }
        
        set{
            df.dateFormat = "hh:mm a"
            if let date = newValue{
                let dateString = df.stringFromDate(date)
                NSUserDefaults.standardUserDefaults().setObject(dateString, forKey: SleepPreferences.GoToSleepTimePreferenceKey)
            }
        }
    }
    var wakeUpTime: NSDate?{
        get{
            df.dateFormat = "hh:mm a"
            if let dateString = NSUserDefaults.standardUserDefaults().objectForKey(SleepPreferences.WakeUpTimePreferenceKey) as? String
            {
                let date = df.dateFromString(dateString)
                return date
            }
            return NSDate()
        }
        
        set{
            df.dateFormat = "hh:mm a"
            if let date = newValue{
                let dateString = df.stringFromDate(date)
                NSUserDefaults.standardUserDefaults().setObject(dateString, forKey: SleepPreferences.WakeUpTimePreferenceKey)
            }
        }
    }
    private struct StoryBoard{
        static let PickSleepTimeId = "PickSleepTimeViewController"
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        df.dateFormat = "hh:mm a"
        print("\(df.stringFromDate(sleepTime!))")
        print("\(df.stringFromDate(wakeUpTime!))")
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
            
            pickSleepTimeViewController.currentKey = preferenceKey
            pickSleepTimeViewController.titleText = title
            pickSleepTimeViewController.sleepTimeViewController = self
            let popover = pickSleepTimeViewController.popoverPresentationController
            popover?.delegate = self
            popover?.permittedArrowDirections = [.Up, .Down]
            popover?.sourceView = sender
            popover?.sourceRect = sender.bounds
            self.presentViewController(pickSleepTimeViewController, animated: true, completion: nil)
        }
    }
}
