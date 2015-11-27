//
//  AppointmentListViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 26/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
import CoreData
class ListAppointmentViewController: UIViewController, UITableViewDataSource, UIPopoverPresentationControllerDelegate{
    var managedObjectContext: NSManagedObjectContext!
    @IBInspectable
    var colorQuickAction : UIColor!
    var currentAppointment: Appointment?
    
    var appointments = [Appointment](){
        didSet{
            tableView?.reloadData()
        }
    }
    @IBAction func deleteAll(sender: UIButton)
    {
        let title = NSLocalizedString("deleteAppointmentsTitle", tableName: "localization",comment: "Warning title")
        let message = NSLocalizedString("deleteAppointmentsMessage", tableName: "localization", comment: "All appointments will be deleted warning")
        let cancelText = NSLocalizedString("deleteAppointmentsCancel", tableName: "localization", comment: "Cancel deleting appointments")
        let acceptText = NSLocalizedString("deleteAppointmentsAccept", tableName: "localization", comment: "Confirm delete all appointments")
        let alert = UIAlertController(title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: cancelText, style: UIAlertActionStyle.Cancel, handler: {
            (action: UIAlertAction!) in alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: acceptText, style: UIAlertActionStyle.Destructive, handler: {
            (action: UIAlertAction!) in self.deleteAll()
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    private func deleteAll(){
        Appointment.removeAll(managedObjectContext)
        appointments.removeAll()
        tableView?.reloadData()
    }
    func deleteAppointment(appointment: Appointment?){
        
        let title = NSLocalizedString("deleteAppointmentTitle", tableName: "localization",comment: "Warning title")
        let message = NSLocalizedString("deleteAppointmentMessage", tableName: "localization", comment: "An appointment will be deleted warning")
        let cancelText = NSLocalizedString("deleteAppointmentCancel", tableName: "localization", comment: "Cancel deleting an appointment")
        let acceptText = NSLocalizedString("deleteAppointmentAccept", tableName: "localization", comment: "Confirm delete an appointment")
        let alert = UIAlertController(title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: cancelText, style: UIAlertActionStyle.Cancel, handler: {
            (action: UIAlertAction!) in alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: acceptText, style: UIAlertActionStyle.Destructive, handler: {
            (action: UIAlertAction!) in self.deleteAppointmentConfirmed(appointment)
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func deleteAppointmentConfirmed(appointment: Appointment?){
        if appointment != nil{
            if let index = appointments.indexOf(appointment!){
                appointments.removeAtIndex(index)
            }
            Appointment.delete(managedObjectContext, appointment: appointment!)
        }
        tableView?.reloadData()
    }
    func showAppointment(appointment: Appointment?, sender: UIView){
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let viewAppointmentViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.ViewAppointmentId) as? ViewAppointmentViewController)
        {
            
            viewAppointmentViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            viewAppointmentViewController.appointment = appointment
            let popover = viewAppointmentViewController.popoverPresentationController
            popover?.delegate = self
            popover?.sourceView = sender
            self.presentViewController(viewAppointmentViewController, animated: true, completion: nil)
        }
    }
    func editAppointment(appointment: Appointment?, sender: UIView){
        currentAppointment = appointment
        showCreateAppointment(sender)
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    func showCreateAppointment(sender: UIView){
        performSegueWithIdentifier(SegueIdentifier.IdentifierCreateNewAppointment, sender: sender)
    }
    @IBAction func createAppointment(sender: UIButton){
        showCreateAppointment(sender)
    }
    private func initAppointments(){
        appointments = Appointment.getAll(managedObjectContext) ?? []
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initAppointments()
    }
    @IBOutlet var tableView: UITableView!{
        didSet{
            tableView?.dataSource = self
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AppointmentCell", forIndexPath: indexPath) as? AppointmentCell
        let appointment = appointments[indexPath.row]
        cell?.appointment = appointment
        cell?.buttonEdit.tag = indexPath.row
        cell?.buttonEdit.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
        cell?.buttonEdit.addTarget(self, action: "showEditView:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell!
    }
    
    func showEditView(sender: UIButton)
    {
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let editItemViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.AppointmentItemOptionsViewId) as? AppointmentOptionsViewController)
        {
            
            editItemViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            editItemViewController.appointment = appointments[sender.tag]
            editItemViewController.editAppointment = editAppointment
            editItemViewController.deleteAppointment = deleteAppointment
            editItemViewController.showAppointment = showAppointment
            editItemViewController.sender = sender
            let popover = editItemViewController.popoverPresentationController
            popover?.delegate = self
            popover?.permittedArrowDirections = [.Up, .Down]
            popover?.sourceView = sender
            popover?.sourceRect = sender.bounds
            popover?.backgroundColor = colorQuickAction
            self.presentViewController(editItemViewController, animated: true, completion: nil)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as UIViewController
        if let createAppointmentViewController = destination as? CreateAppointmentViewController
        {
            createAppointmentViewController.appointment = currentAppointment
            currentAppointment  = nil
        }
    }
}
