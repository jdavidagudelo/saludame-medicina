//
//  ScheduleMedicationViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 12/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
import CoreData

class ScheduleMedicationViewController: UIViewController, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    
    private struct StoryBoard{
        static let PickStartTimeViewId = "PickStartTimeScheduleViewController"
        static let CustomToastViewId = "CustomToastUIViewController"
    }
    var toastMessage: String? = NSLocalizedString("toastInvalidModificationText", tableName: "localization",
        comment: "Invalid modification of time")
    var managedObjectContext: NSManagedObjectContext!
    var events = [Evento](){
        didSet{
            if !events.isEmpty
            {
                var currentHours = [String]()
                var currentTimes = [Int]()
                startTime = TimeUtil.dateFromMinutesOfDay(Int(events[0].time ?? 0))
                for event in events{
                    if let time = event.time as? Int{
                        currentHours += [TimeUtil.textFromMinute(time)]
                        currentTimes += [time]
                    }
                }
                hours = currentHours
                times = currentTimes
            }
            else{
                initHours()
            }
        }
    }
    var df = NSDateFormatter()
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView?.dataSource = self
        }
    }
    @IBOutlet weak var labelIndications: UILabel!{
        didSet{
            labelIndications?.text = medicamento?.indicaciones
        }
    }
    var medicamento: Medicamento?{
        didSet{
            labelIndications?.text = medicamento?.indicaciones
        }
    }
    var times = [Int]()
    var hours = [String](){
        didSet{
            tableView?.reloadData()
        }
    }
    var startMinuteDay: Double?{
        get{
            if let start = startTime{
                return TimeUtil.dayMinuteFromDate(start)
            }
            return TimeUtil.dayMinuteFromDate(wakeUpTime ?? NSDate())
        }
    }
    var endMinuteDay: Double?
    var startTime: NSDate?{
        didSet{
            initHours()
        }
    }
    var timesDay : Int {
        get{
            return Int(24.0/Double((medicamento?.periodicidad) ?? 1.0))
        }
    }
    var goToSleepTime : NSDate?{
        get{
            return NSDate()
        }
    }
    var wakeUpTime: NSDate?{
        
        get{
            df.dateFormat = "hh:mm a"
            if let dateString = NSUserDefaults.standardUserDefaults().objectForKey(SleepPreferences.WakeUpTimePreferenceKey) as? String
            {
                if let date = df.dateFromString(dateString)
                {
                    return date
                }
            }
            return NSDate()
        }
    }
    private func initHours(){
        if let m = medicamento
        {
            if startMinuteDay != nil{
                let values = Scheduler.distibuteOverDay(timesDay, period: Int(m.periodicidad!), wakeUpTime: startMinuteDay!)
                var currentHours = [String]()
                var currentTimes = [Int]()
                for minutes in values{
                    currentHours += [TimeUtil.textFromMinute(minutes)]
                    currentTimes += [minutes]
                }
                hours = currentHours
                times = currentTimes
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        fetchEvents()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchEvents()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func testDateMedication(date: NSDate){
        
    }
    private func validateMedication() -> Bool{
        if let time = medicamento?.fechaFin?.timeIntervalSince1970
        {
            return TimeUtil.secondsToMinutes(time) < TimeUtil.todayStartMinutes()
        }
        return false
    }
    private func fetchEvents(){
        events = Evento.getCyclicEvents(managedObjectContext, medicamento: medicamento) ?? [Evento]()
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return hours.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HourMedicationCell", forIndexPath: indexPath) as? HourMedicationViewCell
        cell?.dateText = hours[indexPath.row]
        cell?.buttonEdit.tag = indexPath.row
        if indexPath.row == 0{
            cell?.buttonEdit.addTarget(self, action: "showPickDate:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        else{
            cell?.buttonEdit.addTarget(self, action: "showToast:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        return cell!
    }
    func showPickDate(sender: UIButton)
    {
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let pickStartTimeScheduleViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.PickStartTimeViewId) as? PickStartTimeScheduleViewController)
        {
            
            pickStartTimeScheduleViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            pickStartTimeScheduleViewController.date = startTime
            pickStartTimeScheduleViewController.scheduleMedicationViewController = self
            let popover = pickStartTimeScheduleViewController.popoverPresentationController
            popover?.delegate = self
            popover?.permittedArrowDirections = [.Up, .Down]
            popover?.sourceView = sender
            popover?.sourceRect = sender.bounds
            self.presentViewController(pickStartTimeScheduleViewController, animated: true, completion: nil)
        }
    }
    @IBAction func cancel(sender: UIButton){
        navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func save(sender: UIButton){
        Evento.archiveEvents(managedObjectContext, medicamento: medicamento)
        for time in times{
            Evento.createInManagedObjectContext(managedObjectContext, medicamento: medicamento, cycle: EventPeriod.Daily, time: time, type: EventType.Medication, state: EventState.Active)
        }
        navigationController?.popViewControllerAnimated(true)
    }
    func showToast(sender : UIButton)
    {
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let toastViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.CustomToastViewId) as? CustomToastUIViewController)
        {
            
            toastViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            toastViewController.currentText = toastMessage
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
