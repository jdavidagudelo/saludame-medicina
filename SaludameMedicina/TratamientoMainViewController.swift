//
//  TratamientoMainViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 4/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class TratamientoMainViewController: UIViewController, UITableViewDataSource {
    func showMedicationSchedule(sender: UIButton){
        performSegueWithIdentifier(SegueIdentifier.IdentifierMedicationSchedule, sender: sender)
    }
    func showFormulas(sender: UIButton){
        performSegueWithIdentifier(SegueIdentifier.IdentifierShowFormulas, sender: sender)
    }
    func showMedicamentos(sender: UIButton)
    {
        performSegueWithIdentifier(SegueIdentifier.IdentifierShowMedicamentos, sender: sender)
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TratamientoCustomButtonCell", forIndexPath: indexPath) as? CustomButtonCell
        cell?.information = customButtons?[indexPath.row]
        cell?.backgroundColor = UIColor.clearColor()
        return cell!
    }
    @IBInspectable var iconFormula: UIImage?
    @IBInspectable var iconMedication: UIImage?
    @IBInspectable var iconSchedule: UIImage?
    @IBInspectable var iconDevices: UIImage?
    private func initCustomButtons(){
        var currentCustomButtons : [(title: String?, description: String?, icon: UIImage?, action: ((sender: UIButton) -> Void)?)]
        currentCustomButtons = []
        let formulasTitle: String? = NSLocalizedString("formulasTitle", tableName: "localization",
            comment: "The dose prefix")
        let formulasDescription: String? = NSLocalizedString("formulasDescription", tableName: "localization",
            comment: "The dose prefix")
        let actionFormula : ((sender: UIButton) -> Void)? = showFormulas
        currentCustomButtons += [(title: formulasTitle, description: formulasDescription, icon: iconFormula, action: actionFormula)]
        let medicationsTitle: String? = NSLocalizedString("medicationsTitle", tableName: "localization",
            comment: "The dose prefix")
        let medicationsDescription: String? = NSLocalizedString("medicationsDescription", tableName: "localization",
            comment: "The dose prefix")
        let actionMedications : ((sender: UIButton) -> Void)? = showMedicamentos
        currentCustomButtons += [(title: medicationsTitle, description: medicationsDescription, icon: iconMedication, action: actionMedications)]
        let scheduleTitle: String? = NSLocalizedString("scheduleTitle", tableName: "localization",
            comment: "The dose prefix")
        let scheduleDescription: String? = NSLocalizedString("scheduleDescription", tableName: "localization",
            comment: "The dose prefix")
        let actionSchedule : ((sender: UIButton) -> Void)? = showMedicationSchedule
        currentCustomButtons += [(title: scheduleTitle, description: scheduleDescription, icon: iconSchedule, action: actionSchedule)]
        let devicesTitle: String? = NSLocalizedString("devicesTitle", tableName: "localization",
            comment: "The dose prefix")
        let devicesDescription: String? = NSLocalizedString("devicesDescription", tableName: "localization",
            comment: "The dose prefix")
        let actionDevices : ((sender: UIButton) -> Void)? = nil
        currentCustomButtons += [(title: devicesTitle, description: devicesDescription, icon: iconDevices, action: actionDevices)]
        customButtons = currentCustomButtons
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
