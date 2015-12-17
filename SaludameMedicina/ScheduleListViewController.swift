//
//  ScheduleListViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 21/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
import CoreData

class ScheduleListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate
{
    let toastMessageStateScheduled: String! = NSLocalizedString("toastMessageStateScheduled", tableName: "localization",
        comment: "Medication has already been scheduled") ?? ""
    let toastMessageStateNotScheduled: String! = NSLocalizedString("toastMessageStateNotScheduled", tableName: "localization",
        comment: "Medication has not been scheduled") ?? ""
    var medications = [Medicamento]()
    @IBInspectable var iconOpen: UIImage!
    @IBInspectable var iconClosed: UIImage!
    @IBInspectable var iconNotScheduled: UIImage!
    @IBInspectable var iconScheduled: UIImage!
    var events = [[Evento]]()
    var headerCells =  [EventsHeaderCell]()
    var sectionStates = [Bool]()
    var managedObjectContext: NSManagedObjectContext!
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    private func initMedications(){
        medications = Medicamento.getAll(managedObjectContext) ?? []
        var currentEventsTable = [[Evento]]()
        for medication in medications{
            let currentEvents = Evento.getCyclicEvents(managedObjectContext, medicamento: medication) ?? []
            currentEventsTable += [currentEvents]
        }
        events = currentEventsTable
        var currentSectionStates = [Bool]()
        for _ in medications{
            currentSectionStates += [false]
        }
        sectionStates = currentSectionStates
        tableView?.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        initMedications()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
    }
    override func viewWillAppear(animated: Bool) {
        initMedications()
    }
    @IBOutlet
    var tableView: UITableView!{
        didSet{
            tableView?.dataSource = self
            tableView?.delegate = self
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section >= headerCells.count{
            return 60
        }
        return headerCells[section].bounds.height
    }
    private func getMedicationStateImage(section: Int) -> UIImage?{
        if section < events.count && events[section].count > 0{
            return iconScheduled
        }
        return iconNotScheduled
    }
    private func getImageViewOpen(section: Int) -> UIImage?{
        
        if section < sectionStates.count && sectionStates[section]{
            return iconOpen
        }
        return iconClosed
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let cell = tableView.dequeueReusableCellWithIdentifier("EventsHeaderCell") as? EventsHeaderCell
        cell?.medication = medications[section]
        cell?.sizeToFit()
        if headerCells.count <= section{
            headerCells += [cell!]
        }
        else{
            headerCells[section] = cell!
        }
        cell?.imageOpen = getImageViewOpen(section)
        cell?.buttonState.tag = section
        cell?.buttonState.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
        cell?.buttonState.addTarget(self, action: "showMedicationState:", forControlEvents: UIControlEvents.TouchUpInside)
        cell?.imageState = getMedicationStateImage(section)
        cell?.buttonEdit.tag = section
        cell?.buttonEdit.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
        cell?.buttonEdit.addTarget(self, action: "editSchedule:", forControlEvents: UIControlEvents.TouchUpInside)
        cell?.buttonOpen.tag = section
        cell?.buttonOpen.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
        cell?.buttonOpen.addTarget(self, action: "updateHeaderState:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell!
    }
    private func getMedicationStateText(section: Int) -> String{
        if section < events.count && events[section].count > 0{
            return toastMessageStateScheduled
        }
        return toastMessageStateNotScheduled
    }
    func showMedicationState(sender: UIButton){
        showToast(getMedicationStateText(sender.tag), sender: sender)
    }
    func editSchedule(sender : UIButton){
        performSegueWithIdentifier(SegueIdentifier.IdentifierEditScheduleMedication, sender: sender)
    }
    func updateHeaderState(sender: UIButton){
        sectionStates[sender.tag] = !sectionStates[sender.tag]
        tableView?.reloadData()
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return medications.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionStates[section]{
            return events[section].count
        }
        return 0
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section > medications.count{
            return ""
        }
        return medications[section].nombre
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EventHourCell", forIndexPath: indexPath) as? EventHourCell
        if indexPath.section < events.count && indexPath.row < events[indexPath.section].count{
            cell?.dateText = TimeUtil.getTimeFormatted(events[indexPath.section][indexPath.row].eventDate ?? NSDate())
        }
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as UIViewController
        if let buttonEdit = sender as? UIButton{
            if let scheduleViewController = destination as? ScheduleMedicationViewController{
                if segue.identifier == SegueIdentifier.IdentifierEditScheduleMedication{
                    if buttonEdit.tag < medications.count{
                        scheduleViewController.medicamento = medications[buttonEdit.tag]
                    }
                }
            }
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
}
