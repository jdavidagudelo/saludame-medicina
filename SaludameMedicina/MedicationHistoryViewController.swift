//
//  MedicationHistoryViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 26/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
import CoreData
class MedicationHistoryViewController: UIViewController, UITableViewDataSource , UIPopoverPresentationControllerDelegate{
    @IBInspectable var iconRejected: UIImage!
    @IBInspectable var iconAccepted: UIImage!
    @IBInspectable var iconDelayed: UIImage!
    @IBInspectable var iconUnknown: UIImage!
    private var pickStartDateTitle = NSLocalizedString("startDateTitle", tableName: "localization",
        comment: "Start date for historic records")
    private var pickEndDateTitle = NSLocalizedString("endDateTitle", tableName: "localization",
        comment: "End date for historic records")
    @IBOutlet var labelStartDate: UILabel!{
        didSet{
            labelStartDate?.text = TimeUtil.getDateFormatted(startDate)
        }
    }
    @IBOutlet var labelEndDate: UILabel!{
        didSet{
            labelEndDate?.text = TimeUtil.getDateFormatted(endDate)
        }
    }
    func changeEndDate(endDate: NSDate) {
        self.endDate = endDate
    }
    func changeStartDate(startDate: NSDate) {
        self.startDate = startDate
    }
    var startDate = NSDate(){
        didSet{
            labelStartDate?.text = TimeUtil.getDateFormatted(startDate)
            reloadEvents()
        }
    }
    private func reloadEvents(){
        let realEndDate = TimeUtil.min(TimeUtil.getDateStartByAddingDays(endDate, days: 1), date2: NSDate())
        let realStartDate = TimeUtil.min(TimeUtil.getDateStart(startDate), date2: NSDate())
        events = Evento.getAllMedicationEventsBetween(managedObjectContext, startDate: realStartDate, endDate: realEndDate)
    }
    var endDate = NSDate(){
        didSet{
            labelEndDate?.text = TimeUtil.getDateFormatted(endDate)
            reloadEvents()
        }
    }
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
    private struct StoryBoard{
        static let ViewEventViewId = "ViewEventViewController"
        static let CustomToastViewId = "CustomToastUIViewController"
        static let PickHistoryDateViewId = "PickHistoryDateViewController"
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    var managedObjectContext: NSManagedObjectContext!
    private func initIcons(){
        icons = [EventAnswer.Accepted: iconAccepted, EventAnswer.Pending: iconRejected, EventAnswer.DoseLost: iconRejected,
            EventAnswer.Delayed: iconDelayed, EventAnswer.Rejected: iconRejected, EventAnswer.Notified: iconRejected]
    }
    private func fetchEvents(){
        reloadEvents()
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
    func showEventView(sender: UIButton){
        let event = events[sender.tag]
        showEventView(sender, event: event)
    }
    func showEventView(sender: UIButton, event: Evento?){
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let viewEventViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.ViewEventViewId) as? ViewEventViewController)
        {
            viewEventViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            viewEventViewController.event = event
            let popover = viewEventViewController.popoverPresentationController
            popover?.delegate = self
            popover?.sourceView = sender
            popover?.backgroundColor = UIColor.whiteColor()
            self.presentViewController(viewEventViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func showDatePickerEndDate(sender: UIButton){
        showDatePicker(sender, date: endDate, saveDate: changeEndDate, title: pickEndDateTitle)
    }
    @IBAction func showDatePickerStartDate(sender: UIButton){
        showDatePicker(sender, date: startDate, saveDate: changeStartDate, title: pickStartDateTitle)
    }
    
    func showDatePicker(sender: UIButton, date: NSDate, saveDate: (date: NSDate) -> Void, title: String?)
    {
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let pickHistoryDateViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.PickHistoryDateViewId) as? PickHistoryDateViewController)
        {
            pickHistoryDateViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            pickHistoryDateViewController.date = date
            pickHistoryDateViewController.titleText = title
            pickHistoryDateViewController.saveDate = saveDate
            let popover = pickHistoryDateViewController.popoverPresentationController
            popover?.delegate = self
            popover?.sourceView = sender
            popover?.backgroundColor = UIColor.whiteColor()
            self.presentViewController(pickHistoryDateViewController, animated: true, completion: nil)
        }
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let date = NSDate()
        let cell = tableView.dequeueReusableCellWithIdentifier("EventHistoryCell", forIndexPath: indexPath) as? EventHistoryCell
        let event = events[indexPath.row]
        cell?.event = event
        cell?.buttonEdit.tag = indexPath.row
        cell?.buttonEdit.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
        cell?.buttonEdit.addTarget(self, action: "showEventView:", forControlEvents: UIControlEvents.TouchUpInside)
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
