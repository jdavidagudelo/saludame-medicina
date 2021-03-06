//
//  DashboardViewcontroller.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 26/10/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import AudioToolbox
import MessageUI
class DashboardViewController: UIViewController, UIPopoverPresentationControllerDelegate, AVAudioPlayerDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var buttonCurrentAction: CustomButton!
    @IBOutlet weak var buttonNewAppointment: CustomButton!
    @IBInspectable var imageNavigationBar: UIImage?
    let requiredText = NSLocalizedString("requiredPatientInfoText", tableName: "localization",comment: "Required patient information text")
    @IBOutlet weak var labelAppointment: UILabel!{
        didSet{
            if appointment != nil{
                labelAppointment?.text = TimeUtil.getDateTimeFormatted(appointment?.date ?? NSDate())
            }
        }
    }
    var appointment: Appointment?{
        didSet{
            if appointment != nil{
                labelAppointment?.text = TimeUtil.getDateTimeFormatted(appointment?.date ?? NSDate())
            }
        }
    }
    @IBOutlet var labelEventText: UILabel!{
        didSet{
            labelEventText?.text = event?.description ?? NSLocalizedString("noEventAvailable", tableName: "localization",comment: "No event available information")
        }
    }
    private var event: Evento?{
        didSet{
            labelEventText?.text = event?.description ?? NSLocalizedString("noEventAvailable", tableName: "localization",comment: "No event available information")
            /*let events = Evento.getEventsWithDate(managedObjectContext, date: NSDate())
            if !events.isEmpty{
                let e = events[0]
                let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = mainStoryboardIpad.instantiateViewControllerWithIdentifier("NotificationMedicationViewController") as? NotificationMedicationViewController
                initialViewController?.eventId = NSURL(fileURLWithPath: "\(e.objectID.URIRepresentation())")
                if initialViewController != nil{
                    presentViewController(initialViewController!, animated: true, completion: nil)
                }
            }*/
        }
    }
    private func showToast(text: String, sender : UIView)
    {
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let toastViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.CustomToastViewId) as? CustomToastUIViewController)
        {
            toastViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            toastViewController.currentText = text
            let popover = toastViewController.popoverPresentationController
            popover?.delegate = self
            popover?.permittedArrowDirections = [.Up, .Down]
            popover?.sourceView = sender
            popover?.sourceRect = sender.bounds
            popover?.backgroundColor = UIColor.blackColor()
            self.presentViewController(toastViewController, animated: true, completion: nil)
        }
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    var managedObjectContext: NSManagedObjectContext!
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail Cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail Saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail Sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail Failed")
        default:
            break
        }
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    override func viewDidLoad() {
        buttonCurrentAction?.backgroundColor = buttonCurrentAction?.backgroundColorDefault
        buttonNewAppointment?.backgroundColor = buttonNewAppointment?.backgroundColorDefault
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        Evento.updateEvents(managedObjectContext)
        Notifier.updateNotifications(managedObjectContext)
        self.navigationController?.navigationBar.translucent = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        //navigationController?.navigationBar.setBackgroundImage(imageNavigationBar, forBarMetrics: .Default)
       
    }
    var audioPlayer:AVAudioPlayer!
  
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        event = Evento.getNextEvent(managedObjectContext)
        appointment = Appointment.getNextAppointment(managedObjectContext)
        self.updateViewConstraints()
    }
    @IBAction func showDiary(sender: UIButton){
        if Patient.testPatient(managedObjectContext){
            performSegueWithIdentifier(SegueIdentifier.IdentifierShowDiary, sender: sender)
        }
        else{
            showToast(requiredText, sender: sender)
        }
    }
    @IBAction func showTratamiento(sender: CustomButton)
    {
        if Patient.testPatient(managedObjectContext){
            performSegueWithIdentifier(SegueIdentifier.IdentifierShowTratamiento, sender: sender)
        }
        else{
            showToast(requiredText, sender: sender)
        }
    }
    @IBAction func showNotificationPreferences(sender: UIButton){
        if Patient.testPatient(managedObjectContext){
            performSegueWithIdentifier(SegueIdentifier.IdentifierShowNotificationPreferences, sender: sender)
        }
        else{
            showToast(requiredText, sender: sender)
        }
    }
    @IBAction func showAbout(sender: UIButton){
        showAboutView(sender)
    }
    @IBAction func showMedicationaction(sender: UIButton){
        if event?.medicamento != nil{
            showMedication(sender, medication: event?.medicamento)
        }
    }
    @IBAction func showAppointment(sender: UIButton){
        if appointment != nil{
            showAppointment(sender, appointment: appointment)
        }
    }
    @IBAction func showAdherence(sender: UIButton){
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let adherenceViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.AdherenceLevelViewId) as? AdherenceLevelViewController)
        {
            adherenceViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            let popover = adherenceViewController.popoverPresentationController
            popover?.delegate = self
            popover?.sourceView = sender
            popover?.backgroundColor = UIColor.whiteColor()
            self.presentViewController(adherenceViewController, animated: true, completion: nil)
        }
    }
    func showAppointment(sender: UIButton, appointment: Appointment?){
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let viewAppointmentViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.ViewAppointmentId) as? ViewAppointmentViewController)
        {
            viewAppointmentViewController.appointment = appointment
            viewAppointmentViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            let popover = viewAppointmentViewController.popoverPresentationController
            popover?.delegate = self
            popover?.sourceView = sender
            popover?.backgroundColor = UIColor.whiteColor()
            self.presentViewController(viewAppointmentViewController, animated: true, completion: nil)
        }
    }
    func showAboutView(sender: UIButton   ){
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let aboutViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.AboutViewId) as? AboutViewController)
        {
            aboutViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            let popover = aboutViewController.popoverPresentationController
            popover?.delegate = self
            popover?.sourceView = sender
            popover?.permittedArrowDirections = [.Up]
            popover?.backgroundColor = UIColor.whiteColor()
            self.presentViewController(aboutViewController, animated: true, completion: nil)
        }
    }
    func showMedication(sender: UIButton, medication: Medicamento?){
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let viewMedicationViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.ViewMedicationId) as? ViewMedicationViewController)
        {
            viewMedicationViewController.medication = medication
            viewMedicationViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            let popover = viewMedicationViewController.popoverPresentationController
            popover?.delegate = self
            popover?.sourceView = sender
            popover?.backgroundColor = UIColor.whiteColor()
            self.presentViewController(viewMedicationViewController, animated: true, completion: nil)
        }
    }
    @IBAction func playSound(sender: UIButton) {
        let fileUrl = NSURL(fileURLWithPath: "/System/Library/Audio/UISounds/shake.caf")
        //let audioFilePath = NSBundle.mainBundle().pathForResource("alarm", ofType: "mp3")
        var mySound: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(fileUrl, &mySound)
        // Play
        AudioServicesPlaySystemSound(mySound);
        
    }
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("Playing is over")
        audioPlayer = nil
    }
}