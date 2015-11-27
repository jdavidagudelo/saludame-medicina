//
//  DairyViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 23/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class DairyViewController: UIViewController, UITableViewDataSource {
    func showListAppointments(sender: UIButton){
        performSegueWithIdentifier(SegueIdentifier.IdentifierShowListAppointments, sender: sender)
    }
    func showDailyMedications(sender: UIButton){
        performSegueWithIdentifier(SegueIdentifier.IdentifierShowDailyMedications, sender: sender)
    }
    
    func showEventsHistory(sender: UIButton){
        performSegueWithIdentifier(SegueIdentifier.IdentifierShowEventsHistory, sender: sender)
    }
    var customButtons : [(title: String?, description: String?, icon: UIImage?, action: ((sender: UIButton) -> Void)?)]?{
        didSet{
            tableView?.reloadData()
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initCustomButtons()
    }
    @IBOutlet var tableView: UITableView!{
        didSet{
            let separator = UIView(frame: CGRectZero)
            tableView?.dataSource = self
            tableView?.tableFooterView = separator
            tableView?.tableHeaderView = separator
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return customButtons?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DiaryCustomButtonCell", forIndexPath: indexPath) as? CustomButtonCell
        cell?.information = customButtons?[indexPath.row]
        return cell!
    }
    
    @IBInspectable var iconDailyRecord: UIImage?
    @IBInspectable var iconAppointments: UIImage?
    @IBInspectable var iconHistoric: UIImage?
    private func initCustomButtons(){
        var currentCustomButtons : [(title: String?, description: String?, icon: UIImage?, action: ((sender: UIButton) -> Void)?)]
        currentCustomButtons = []
        let dailyRecordTitle: String? = NSLocalizedString("dailyRecordTitle", tableName: "localization",
            comment: "The dose prefix")
        let dailyRecordDescription: String? = NSLocalizedString("dailyRecordDescription", tableName: "localization",
            comment: "The dose prefix")
        let actionDailyRecord : ((sender: UIButton) -> Void)? = showDailyMedications
        currentCustomButtons += [(title: dailyRecordTitle, description: dailyRecordDescription, icon: iconDailyRecord, action: actionDailyRecord)]
        let appointmentsTitle: String? = NSLocalizedString("appointmentsTitle", tableName: "localization",
            comment: "The dose prefix")
        let appointmentsDescription: String? = NSLocalizedString("appointmentsDescription", tableName: "localization",
            comment: "The dose prefix")
        let actionAppointments : ((sender: UIButton) -> Void)? = showListAppointments
        currentCustomButtons += [(title: appointmentsTitle, description: appointmentsDescription, icon: iconAppointments, action: actionAppointments)]
        let historicTitle: String? = NSLocalizedString("historicTitle", tableName: "localization",
            comment: "The dose prefix")
        let historicDescription: String? = NSLocalizedString("historicDescription", tableName: "localization",
            comment: "The dose prefix")
        let actionHistoric : ((sender: UIButton) -> Void)? = showEventsHistory
        currentCustomButtons += [(title: historicTitle, description: historicDescription, icon: iconHistoric, action: actionHistoric)]
        customButtons = currentCustomButtons
        
    }
}
