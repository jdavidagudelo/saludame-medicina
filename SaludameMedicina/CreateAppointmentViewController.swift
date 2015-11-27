//
//  CreateAppointmentViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 26/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
import CoreData
class CreateAppointmentViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    var appointment: Appointment?{
        didSet{
            textFieldDoctorName?.text = appointment?.doctorName
            textFieldDescription?.text = appointment?.descriptionText
            textFieldPlace?.text = appointment?.place
            date = appointment?.date ?? NSDate()
        }
    }
    @IBOutlet weak var labelDoctorName: UILabel!
    @IBOutlet weak var labelPlace: UILabel!
    @IBOutlet weak var textFieldDoctorName: UITextField!{
        didSet{
            textFieldDoctorName?.text = appointment?.doctorName
        }
    }
    @IBOutlet weak var textFieldPlace: UITextField!{
        didSet{
            textFieldPlace?.text = appointment?.place
        }
    }
    @IBOutlet weak var labelDate: UILabel!{
        didSet{
            labelDate?.text = TimeUtil.getDateFormatted(date ?? NSDate())
        }
    }
    @IBOutlet weak var labelTime: UILabel!{
        didSet{
            labelTime?.text = TimeUtil.getTimeFormatted(date ?? NSDate())
        }
    }
    @IBAction func cancel(sender: UIButton){
        navigationController?.popViewControllerAnimated(true)
    }
    var date = NSDate(){
        didSet{
            let currentDate = NSDate()
            if date.compare(currentDate) == .OrderedAscending{
                date = currentDate
            }
            labelDate?.text = TimeUtil.getDateFormatted(date ?? NSDate())
            labelTime?.text = TimeUtil.getTimeFormatted(date ?? NSDate())
        }
    }
    @IBOutlet weak var textFieldDescription: UITextField!{
        didSet{
            textFieldDescription?.text = appointment?.descriptionText
        }
    }
    var managedObjectContext: NSManagedObjectContext!
    
    private struct StoryBoard{
        static let PickAppointmentDateViewId = "PickAppointmentDateViewController"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    func saveTime(currentDate: NSDate){
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: currentDate)
        let componentsDate = calendar.components([.Day, .Month, .Year], fromDate: date ?? NSDate())
        components.day = componentsDate.day
        components.month = componentsDate.month
        components.year = componentsDate.year
        components.second = 0
        let dateFromComponents : NSDate? = calendar.dateFromComponents(components)
        date = dateFromComponents ?? NSDate()
    }
    func saveDate(currentDate: NSDate){
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: currentDate)
        let componentsDate = calendar.components([.Hour, .Minute], fromDate: date ?? NSDate())
        components.hour = componentsDate.hour
        components.minute = componentsDate.minute
        components.second = 0
        let dateFromComponents : NSDate? = calendar.dateFromComponents(components)
        date = dateFromComponents ?? NSDate()
    }
    @IBAction func saveAppointment(sender: UIButton){
        if textFieldDoctorName?.text?.isEmpty ?? true{
            labelDoctorName?.textColor = UIColor.redColor()
            if textFieldPlace?.text?.isEmpty ?? true{
                labelPlace?.textColor = UIColor.redColor()
            }
            return
        }
        else if textFieldPlace?.text?.isEmpty ?? true{
            labelPlace?.textColor = UIColor.redColor()
            return
        }
        if appointment  == nil{
            Appointment.save(managedObjectContext, doctorName: textFieldDoctorName?.text, place: textFieldPlace?.text, date: date, description: textFieldDescription?.text)
        }
        else{
            appointment?.doctorName = textFieldDoctorName?.text
            appointment?.place = textFieldPlace?.text
            appointment?.descriptionText = textFieldDescription?.text
            appointment?.date = date
            Appointment.save(managedObjectContext)
        }
        navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func showDatePicker(sender: UIButton){
        showDatePicker(sender, date: date ?? NSDate(), saveDate: saveDate, datePickerMode: UIDatePickerMode.Date)
    }
    @IBAction func showTimePicker(sender: UIButton){
        showDatePicker(sender, date: date ?? NSDate(), saveDate: saveTime, datePickerMode: UIDatePickerMode.Time)
    }
    func showDatePicker(sender: UIButton, date: NSDate, saveDate: ((date: NSDate) -> Void)?, datePickerMode: UIDatePickerMode)
    {
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let pickAppointmentDateViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.PickAppointmentDateViewId) as? PickAppointmentDateViewController)
        {
            pickAppointmentDateViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            pickAppointmentDateViewController.date = date
            pickAppointmentDateViewController.saveDate = saveDate
            pickAppointmentDateViewController.datePickerMode = datePickerMode
            let popover = pickAppointmentDateViewController.popoverPresentationController
            popover?.delegate = self
            popover?.sourceView = sender
            popover?.backgroundColor = UIColor.whiteColor()
            self.presentViewController(pickAppointmentDateViewController, animated: true, completion: nil)
        }
    }
}
