//
//  PatientMainViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 12/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class PatientMainViewController: UIViewController {
    private struct SegueIdentifier{
        static let IdentifierSleepTime = "Show Sleep Time"
        static let IdentifierPatientInfo = "Show Patient Info"
    }
    @IBAction func showSleepTime(sender: UIButton){
        performSegueWithIdentifier(SegueIdentifier.IdentifierSleepTime, sender: sender)
    }
    @IBAction func showPatientInfo(sender: UIButton){
        performSegueWithIdentifier(SegueIdentifier.IdentifierPatientInfo, sender: sender)
    }
    
}
