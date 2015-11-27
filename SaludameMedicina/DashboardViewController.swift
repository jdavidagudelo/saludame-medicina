//
//  DashboardViewcontroller.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 26/10/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
import CoreData
class DashboardViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var buttonCurrentAction: CustomButton!
    @IBOutlet weak var buttonNewAppointment: CustomButton!
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
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
    
        buttonCurrentAction?.backgroundColor = buttonCurrentAction?.backgroundColorDefault
        buttonNewAppointment?.backgroundColor = buttonNewAppointment?.backgroundColorDefault
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        Evento.updateEvents(managedObjectContext)
        Notifier.updateNotifications(managedObjectContext)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        event = Evento.getNextEvent(managedObjectContext)
        appointment = Appointment.getNextAppointment(managedObjectContext)
    }
    @IBAction func showDiary(sender: UIButton){
        performSegueWithIdentifier(SegueIdentifier.IdentifierShowDiary, sender: sender)
    }
    @IBAction func showTratamiento(sender: CustomButton)
    {
        performSegueWithIdentifier(SegueIdentifier.IdentifierShowTratamiento, sender: sender)
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
 
}
