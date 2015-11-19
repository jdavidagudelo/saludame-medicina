//
//  PickLostDoseCauseViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 19/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class PickLostDoseCauseViewController: UIViewController, UITableViewDataSource {
    
    @IBInspectable
    var popoverHeight : CGFloat = CGFloat(200.0)
    var switches = [UISwitch?]()
    var cancelEvent: (() -> Void)?
    
    var lostDoseCause = [NSLocalizedString("lostDoseItem1", tableName: "localization",comment: "Lost dose Item 1"),
        NSLocalizedString("lostDoseItem2", tableName: "localization",comment: "Lost dose Item 1"),
        NSLocalizedString("lostDoseItem3", tableName: "localization",comment: "Lost dose Item 1"),
        NSLocalizedString("lostDoseItem4", tableName: "localization",comment: "Lost dose Item 1")]
    @IBOutlet
    var tableView: UITableView!{
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
        return lostDoseCause.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LostDoseCauseCell", forIndexPath: indexPath) as? LostDoseCauseCell
        cell?.value = false
        cell?.currentText = "\(lostDoseCause[indexPath.row])"
        if switches.count <= indexPath.row{
            switches.append(cell?.switchSelectItem)
        }
        else{
            switches[indexPath.row] = cell?.switchSelectItem
        }
        cell?.switchSelectItem.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
        cell?.switchSelectItem.tag = indexPath.row
        cell?.switchSelectItem.addTarget(self, action: "updateSwitch:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell!
    }
    
    func updateSwitch(currentSwitch: UISwitch){
        for x in switches{
            if x?.tag != currentSwitch.tag && x?.tag != nil{
                x?.on = false
            }
        }
        currentSwitch.on = true
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
    
    @IBAction func cancel(sender:UIButton){
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func save(sender:UIButton){
        dismissViewControllerAnimated(true, completion: nil)
        cancelEvent?()
    }
}
