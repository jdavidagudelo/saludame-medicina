//
//  AppointmentOptionViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 26/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class AppointmentOptionsViewController: UIViewController {
    @IBInspectable
    var popoverHeight : CGFloat = CGFloat(90.0)
    @IBInspectable
    var popoverWidth  : CGFloat = CGFloat(100.0)
    var appointment : Appointment?
    var sender: UIView?
    var deleteAppointment: ((appointment: Appointment?) -> Void)?
    var showAppointment: ((appointment: Appointment?, sender: UIView) -> Void)?
    var editAppointment: ((appointment: Appointment?, sender: UIView) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredContentSize: CGSize {
        get{
            if  presentingViewController != nil {
                return CGSize(width: popoverWidth, height: popoverHeight)
            }
            else{
                return super.preferredContentSize
            }
        }
        set{super.preferredContentSize = newValue}
    }
    @IBAction func showAppointment(sender: UIButton){
        dismissViewControllerAnimated(true, completion: nil)
        if let senderView = self.sender{
            showAppointment?(appointment: appointment, sender: senderView)
        }
        
    }
    @IBAction func editAppointment(sender: UIButton)
    {
        dismissViewControllerAnimated(true, completion: nil)
        editAppointment?(appointment: appointment, sender: sender)
    }
    @IBAction func deleteAppointment(sender: UIButton)
    {
        dismissViewControllerAnimated(true, completion: nil)
        deleteAppointment?(appointment: appointment)
    }
}
