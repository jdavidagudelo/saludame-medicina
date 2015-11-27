//
//  ViewAppointmentViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 27/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class ViewAppointmentViewController: UIViewController, UITableViewDataSource {

    @IBInspectable
    var colorCellEven : UIColor?
    @IBInspectable
    var colorCellOdd : UIColor?
    var appointment: Appointment?{
        didSet{
            initData()
        }
    }
    var appointmentData = [(title: String?, description: String?)](){
        didSet{
            tableView?.reloadData()
        }
    }
    @IBOutlet
    var tableView: UITableView!{
        didSet{
            tableView?.estimatedRowHeight = tableView.rowHeight
            tableView?.rowHeight = UITableViewAutomaticDimension
            tableView?.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        return appointmentData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AppointmentItemInfoCell", forIndexPath: indexPath) as? ItemInfoViewCell
        cell?.info = appointmentData[indexPath.row]
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
    private func initData(){
        var currentAppointmentData = [(title: String?, description: String?)]()
        currentAppointmentData += [(title: Optional(NSLocalizedString("appointmentDoctorNameTitle", tableName: "localization",
            comment: "Appointment doctor name title")), description: appointment?.doctorName)]
        currentAppointmentData += [(title: Optional(NSLocalizedString("appointmentPlaceTitle", tableName: "localization",
            comment: "Appointment place title")), description: appointment?.place)]
        currentAppointmentData += [(title: Optional(NSLocalizedString("appointmentDateTitle", tableName: "localization",
            comment: "Appointment date title")), description: Optional(TimeUtil.getDateFormatted(appointment?.date ?? NSDate())))]
        currentAppointmentData += [(title: Optional(NSLocalizedString("appointmentTimeTitle", tableName: "localization",
            comment: "Appointment time title")), description: Optional(TimeUtil.getTimeFormatted(appointment?.date ?? NSDate())))]
        currentAppointmentData += [(title: Optional(NSLocalizedString("appointmentDescriptionTitle", tableName: "localization",
            comment: "Appointment description title")), description: appointment?.descriptionText)]
        appointmentData = currentAppointmentData
    }
}
