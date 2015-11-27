//
//  DairyViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 23/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class DairyViewController: UIViewController {
    private struct SegueIdentifier{
        static let IdentifierShowDailyMedications = "Show Daily Medications"
        static let IdentifierShowEventsHistory = "Show Events History"
        static let IdentifierShowListAppointments = "List Appointmets"
    }
    @IBAction func showListAppointments(sender: UIButton){
        performSegueWithIdentifier(SegueIdentifier.IdentifierShowListAppointments, sender: sender)
    }
    @IBAction func showDailyMedications(sender: UIButton){
        performSegueWithIdentifier(SegueIdentifier.IdentifierShowDailyMedications, sender: sender)
    }
    
    @IBAction func showEventsHistory(sender: UIButton){
        performSegueWithIdentifier(SegueIdentifier.IdentifierShowEventsHistory, sender: sender)
    }
}
