//
//  NotificationsMainViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 18/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class NotificationsMainViewController: UIViewController, UITableViewDataSource {

    func showMessagePreference(sender: UIButton){
        performSegueWithIdentifier(SegueIdentifier.IdentifierShowMessagePreference, sender: sender)
    }
    var customButtons : [(title: String?, description: String?, icon: UIImage?, action: ((sender: UIButton) -> Void)?)]?{
        didSet{
            tableView?.reloadData()
        }
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
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initCustomButtons()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return customButtons?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NotificationCustomButtonCell", forIndexPath: indexPath) as? CustomButtonCell
        cell?.information = customButtons?[indexPath.row]
        cell?.backgroundColor = UIColor.clearColor()
        return cell!
    }
    
    @IBInspectable var iconAlarmPreference: UIImage?
    @IBInspectable var iconMessagesPreference: UIImage?
    @IBInspectable var iconCompanionPreferences: UIImage?
    @IBInspectable var iconAppointmentsPreferences: UIImage?
    
    private func initCustomButtons(){
        var currentCustomButtons : [(title: String?, description: String?, icon: UIImage?, action: ((sender: UIButton) -> Void)?)]
        currentCustomButtons = []
        let alarmTitle: String? = NSLocalizedString("alarmTitle", tableName: "localization",
            comment: "The dose prefix")
        let alarmDescription: String? = NSLocalizedString("alarmDescription", tableName: "localization",
            comment: "The dose prefix")
        let actionAlarm : ((sender: UIButton) -> Void)? = nil
        currentCustomButtons += [(title: alarmTitle, description: alarmDescription, icon: iconAlarmPreference, action: actionAlarm)]
        let messagesTitle: String? = NSLocalizedString("messagesTitle", tableName: "localization",
            comment: "The dose prefix")
        let messagesDescription: String? = NSLocalizedString("messagesDescription", tableName: "localization",
            comment: "The dose prefix")
        let actionMessages : ((sender: UIButton) -> Void)? = showMessagePreference
        currentCustomButtons += [(title: messagesTitle, description: messagesDescription, icon: iconMessagesPreference, action: actionMessages)]
        let notificationsCompanionTitle: String? = NSLocalizedString("notificationsCompanionTitle", tableName: "localization",
            comment: "The dose prefix")
        let notificationsCompanionDescription: String? = NSLocalizedString("notificationsCompanionDescription", tableName: "localization",
            comment: "The dose prefix")
        let actionNotificationsCompanion : ((sender: UIButton) -> Void)? = nil
        currentCustomButtons += [(title: notificationsCompanionTitle, description: notificationsCompanionDescription, icon: iconCompanionPreferences, action: actionNotificationsCompanion)]
        let appointmentsTitle: String? = NSLocalizedString("appointmentsPreferencesTitle", tableName: "localization",
            comment: "The dose prefix")
        let appointmentsDescription: String? = NSLocalizedString("appointmentsPreferencesDescription", tableName: "localization",
            comment: "The dose prefix")
        let actionAppointments : ((sender: UIButton) -> Void)? = nil
        currentCustomButtons += [(title: appointmentsTitle, description: appointmentsDescription, icon: iconAppointmentsPreferences, action: actionAppointments)]
        customButtons = currentCustomButtons
        
    }
}
