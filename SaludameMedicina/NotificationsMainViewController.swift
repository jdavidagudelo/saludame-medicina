//
//  NotificationsMainViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 18/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class NotificationsMainViewController: UIViewController {
    private struct SegueIdentifier{
        static let IdentifierShowMessagePreference = "Show Message Preferences"
    }
    @IBAction func showMessagePreference(sender: UIButton){
        performSegueWithIdentifier(SegueIdentifier.IdentifierShowMessagePreference, sender: sender)
    }
    /*@IBAction func showPatientInfo(sender: UIButton){
        performSegueWithIdentifier(SegueIdentifier.IdentifierPatientInfo, sender: sender)
    }
    @IBAction func showCompanionInfo(sender : UIButton){
        performSegueWithIdentifier(SegueIdentifier.IdentifierCompanionInfo, sender: sender)
    }*/
}
