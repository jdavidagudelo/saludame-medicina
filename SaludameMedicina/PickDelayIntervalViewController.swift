//
//  PickDelayIntervalViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 19/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class PickDelayIntervalViewController: UIViewController, UITableViewDataSource{
    @IBInspectable
    var popoverHeight : CGFloat = CGFloat(200.0)
    var changeInterval : ((Int) -> Void)?
    var delayIntervals = [1,5, 15, 30]
    var switches = [UISwitch?]()
    var currentInterval = 1
    @IBOutlet
    var tableView: UITableView!{
        didSet{
            tableView?.dataSource = self
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delayIntervals.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DelayIntervalCell", forIndexPath: indexPath) as? DelayIntervalCell
        cell?.value = false
        cell?.currentText = "\(delayIntervals[indexPath.row])"
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
        currentInterval = delayIntervals[currentSwitch.tag]
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
        changeInterval?(currentInterval)
    }
}
