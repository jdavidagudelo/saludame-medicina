//
//  PatientMainViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 12/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class PatientMainViewController: UIViewController, UITableViewDataSource {
    func showSleepTime(sender: UIButton){
        performSegueWithIdentifier(SegueIdentifier.IdentifierSleepTime, sender: sender)
    }
    func showPatientInfo(sender: UIButton){
        performSegueWithIdentifier(SegueIdentifier.IdentifierPatientInfo, sender: sender)
    }
    func showCompanionInfo(sender : UIButton){
        performSegueWithIdentifier(SegueIdentifier.IdentifierCompanionInfo, sender: sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initCustomButtons()
    }
    var customButtons : [(title: String?, description: String?, icon: UIImage?, action: ((sender: UIButton) -> Void)?)]?{
        didSet{
            tableView?.reloadData()
        }
    }
    @IBOutlet var tableView: UITableView!{
        didSet{
            tableView?.dataSource = self
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PatientCustomButtonCell", forIndexPath: indexPath) as? CustomButtonCell
        cell?.information = customButtons?[indexPath.row]
        cell?.backgroundColor = UIColor.clearColor()
        return cell!
    }
    
    @IBInspectable var iconPatientInfo: UIImage?
    @IBInspectable var iconSleepTime: UIImage?
    @IBInspectable var iconCompanion: UIImage?
    private func initCustomButtons(){
        var currentCustomButtons : [(title: String?, description: String?, icon: UIImage?, action: ((sender: UIButton) -> Void)?)]
        currentCustomButtons = []
        let patientInfoTitle: String? =  NSLocalizedString("patientInfoTitle", tableName: "localization",
            comment: "The dose prefix")
        let patientInfoDescription: String? =  NSLocalizedString("patientInfoDescription", tableName: "localization",
            comment: "The dose prefix")
        let actionPatientInfo : ((sender: UIButton) -> Void)? = showPatientInfo
        currentCustomButtons += [(title: patientInfoTitle, description: patientInfoDescription, icon: iconPatientInfo, action: actionPatientInfo)]
        let sleepTimeTitle: String? =  NSLocalizedString("sleepTimeTitle", tableName: "localization",
            comment: "The dose prefix")
        let sleepTimeDescription: String? =  NSLocalizedString("sleepTimeDescription", tableName: "localization",
            comment: "The dose prefix")
        let actionSleepTime : ((sender: UIButton) -> Void)? = showSleepTime
        currentCustomButtons += [(title: sleepTimeTitle, description: sleepTimeDescription, icon: iconSleepTime, action: actionSleepTime)]
        let companionInfoTitle: String? =  NSLocalizedString("companionInfoTitle", tableName: "localization",
            comment: "The dose prefix")
        let companionInfoDescription: String? =  NSLocalizedString("companionInfoDescription", tableName: "localization",
            comment: "The dose prefix")
        let actionCompanionInfo : ((sender: UIButton) -> Void)? = showCompanionInfo
        currentCustomButtons += [(title: companionInfoTitle, description: companionInfoDescription, icon: iconCompanion, action: actionCompanionInfo)]
        customButtons = currentCustomButtons
        
    }

}
