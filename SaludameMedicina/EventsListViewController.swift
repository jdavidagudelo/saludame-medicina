//
//  EventsListViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 23/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
import CoreData

class EventsListViewController: UIViewController, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    @IBInspectable var iconRejected: UIImage!
    @IBInspectable var iconAccepted: UIImage!
    @IBInspectable var iconDelayed: UIImage!
    @IBInspectable var iconUnknown: UIImage!
    var icons = [NSNumber: UIImage]()
    var events = [Evento](){
        didSet{
            tableView?.reloadData()
        }
    }
    let toastMessageMedicationLost : String! = NSLocalizedString("medicationLost", tableName: "localization",
        comment: "The medication was lost") ?? ""
    let toastMessageMedicationDone : String! = NSLocalizedString("medicationDone", tableName: "localization",
        comment: "The medication was taken successfully") ?? ""
    
    func reload(){
        tableView?.reloadData()
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    var managedObjectContext: NSManagedObjectContext!
    private func initIcons(){
        icons = [EventAnswer.Accepted: iconAccepted, EventAnswer.Pending: iconUnknown, EventAnswer.DoseLost: iconRejected,
            EventAnswer.Delayed: iconDelayed, EventAnswer.Rejected: iconRejected, EventAnswer.Notified: iconUnknown]
    }
    private func fetchEvents(){
        events = Evento.getAllMedicationEventsBetween(managedObjectContext, startDate: TimeUtil.getTodayStart(), endDate: TimeUtil.getTomorrowStart())
        print("\(events.count)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        initIcons()
    }
    override func viewWillAppear(animated: Bool) {
        fetchEvents()
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
        return events.count
    }
    func validEdit(event: Evento) -> Bool{
        let date = NSDate()
        if date.compare(event.eventDate ?? NSDate()) == .OrderedDescending && (event.response == EventAnswer.Pending ||
            EventAnswer.Notified == event.response){
            return true
        }
        return false
    }
    func showEventEdit(sender: UIButton){
        let event = events[sender.tag]
        
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if validEdit(event){
            if let editEventStateViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.EventEditViewId) as? EditEventStateViewController)
            {
                editEventStateViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
                editEventStateViewController.reload = reload
                editEventStateViewController.event = event
                let popover = editEventStateViewController.popoverPresentationController
                popover?.delegate = self
                popover?.sourceView = sender
                popover?.backgroundColor = UIColor.whiteColor()
                self.presentViewController(editEventStateViewController, animated: true, completion: nil)
            }
        }
        else if event.response == EventAnswer.Rejected || event.response == EventAnswer.DoseLost{
            showToast(toastMessageMedicationLost, sender: sender)
        }
        else if event.response == EventAnswer.Accepted{
            showToast(toastMessageMedicationDone, sender: sender)
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let date = NSDate()
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as? EventCell
        let event = events[indexPath.row]
        cell?.event = event
        cell?.buttonEdit.tag = indexPath.row
        cell?.buttonEdit.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
        cell?.buttonEdit.addTarget(self, action: "showEventEdit:", forControlEvents: UIControlEvents.TouchUpInside)
        if let response = event.response {
            if date.compare(event.eventDate ?? NSDate()) == .OrderedDescending{
                cell?.imageState = icons[response]
            }
            else {
                cell?.imageState = nil
            }
        }
        return cell!
    }
}
