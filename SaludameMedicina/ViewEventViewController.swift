//
//  ViewEventViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 26/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class ViewEventViewController: UIViewController, UITableViewDataSource {
    @IBInspectable
    var popoverHeight: CGFloat = 300
    @IBInspectable
    var colorCellEven : UIColor?
    @IBInspectable
    var colorCellOdd : UIColor?
    var event: Evento?{
        didSet{
            if event == nil{
                dismissViewControllerAnimated(true, completion: nil)
            }
            initData()
        }
    }
    var eventData = [(title: String?, description: String?)](){
        didSet{
            tableView?.reloadData()
        }
    }
    @IBOutlet
    var tableView: UITableView!{
        didSet{
            tableView.estimatedRowHeight = tableView.rowHeight
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView?.dataSource = self
        }
    }
    override var preferredContentSize: CGSize {
        get{
            if  presentingViewController != nil {
                return CGSize(width: super.preferredContentSize.width, height: popoverHeight)
            }
            else{
                return super.preferredContentSize
            }
        }
        set{super.preferredContentSize = newValue}
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeView(sender: UIButton) {
        dismissViewControllerAnimated(true, completion : nil)
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return eventData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EventItemInfoCell", forIndexPath: indexPath) as? ItemInfoViewCell
        cell?.info = eventData[indexPath.row]
        //IOS BUG
        cell?.contentView.frame = (cell?.bounds)!;
        cell?.contentView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight];
        if indexPath.row%2 == 0{
            cell?.colorView = colorCellEven
        }
        else{
            cell?.colorView = colorCellOdd
        }
        return cell!
    }
    
    private func formattedDate(date: NSDate?) -> String?{
        if let d = date{
            return TimeUtil.getDateFormatted(d)
        }
        return ""
    }
    private func getEventAnswer(event: Evento?) -> String?{
        if event?.response == EventAnswer.Accepted{
            return NSLocalizedString("eventAnswerAccepted", tableName: "localization",
                comment: "Event accepted")
        }
        if event?.response == EventAnswer.Delayed{
            return  NSLocalizedString("eventAnswerDelayed", tableName: "localization",
                comment: "Event delayed")
        }
        if event?.response == EventAnswer.DoseLost{
            return NSLocalizedString("eventAnswerDoseLost", tableName: "localization",
                comment: "Event dose lost")
        }
        if event?.response == EventAnswer.Notified || event?.response == EventAnswer.Pending{
            return NSLocalizedString("eventAnswerUnknown", tableName: "localization",
                comment: "Event pending")
        }
        if event?.response == EventAnswer.Rejected{
            return NSLocalizedString("eventAnswerRejected", tableName: "localization",
                comment: "Event rejected")
        }
        return ""
    }
    private func initData(){
        var currentMedicationData = [(title: String?, description: String?)]()
        currentMedicationData += [(title: Optional(NSLocalizedString("eventActionTitle", tableName: "localization",
            comment: "Event action title")), description: event?.nameText)]
        currentMedicationData += [(title: Optional(NSLocalizedString("eventDateTimeTitle", tableName: "localization",
            comment: "Event date time title")), description: Optional(TimeUtil.getDateTimeFormatted(event?.eventDate ?? NSDate())))]
        if let responseTime = event?.responseTime{
            currentMedicationData += [(title: Optional(NSLocalizedString("eventDateTimeResponseTitle", tableName: "localization",
                comment: "Event response time title")),
                description: Optional(TimeUtil.getDateTimeFormatted(responseTime)))]
        }
        currentMedicationData += [(title: Optional(NSLocalizedString("eventResponseTitle", tableName: "localization",
            comment: "Event response title")), description: getEventAnswer(event))]
        eventData = currentMedicationData
    }
}
