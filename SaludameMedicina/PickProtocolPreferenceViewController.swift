//
//  PickProtocolPreferenceViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 18/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
@IBDesignable
class PickProtocolPreferenceViewController: UIViewController {
    @IBInspectable
    var popoverHeight : CGFloat = CGFloat(200.0)
    @IBOutlet var switchFormalProtocol: UISwitch!{
        didSet{
            switchFormalProtocol?.on =
                (NSUserDefaults.standardUserDefaults().objectForKey(NotificationPreferences.ProtocolPreferenceKey) as? NSNumber) == Protocol.Formal
        }
    }
    @IBOutlet var switchInformalProtocol: UISwitch!{
        didSet{
            switchInformalProtocol?.on =
                (NSUserDefaults.standardUserDefaults().objectForKey(NotificationPreferences.ProtocolPreferenceKey) as? NSNumber) == Protocol.Informal
        }
    }
    @IBOutlet var switchNeutralProtocol: UISwitch!{
        didSet{
            switchNeutralProtocol?.on =
                (NSUserDefaults.standardUserDefaults().objectForKey(NotificationPreferences.ProtocolPreferenceKey) as? NSNumber) == Protocol.Neutral
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func updateSwicthFormal(sender: UISwitch){
        if !(sender.on ?? false){
            sender.on = true
        }
        switchInformalProtocol?.on = false
        switchNeutralProtocol?.on = false
    }
    @IBAction func updateSwicthInformal(sender: UISwitch){
        if !(sender.on ?? false){
            sender.on = true
        }
        switchFormalProtocol?.on = false
        switchNeutralProtocol?.on = false
    }
    @IBAction func updateSwicthNeutral(sender: UISwitch){
        if !(sender.on ?? false){
            sender.on = true
        }
        switchFormalProtocol?.on = false
        switchInformalProtocol?.on = false
    }
    @IBAction func save(sender: UIButton){
        var currentProtocol : NSNumber! = Protocol.Formal
        if switchNeutralProtocol?.on ?? false{
            currentProtocol = Protocol.Neutral
        }
        else if switchFormalProtocol?.on ?? false{
            currentProtocol = Protocol.Formal
        }
        else if switchInformalProtocol?.on ?? false{
            currentProtocol = Protocol.Informal
        }
        NSUserDefaults.standardUserDefaults().setObject(currentProtocol, forKey: NotificationPreferences.ProtocolPreferenceKey)
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancel(sendet: UIButton){
        dismissViewControllerAnimated(true, completion: nil)
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
}
