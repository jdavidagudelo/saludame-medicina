//
//  DashboardViewcontroller.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 26/10/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet var buttonCurrentAction: CustomButton!
    @IBOutlet var buttonNewAppointment: CustomButton!
    private struct SegueIdentifier{
        static let IdentifierShowTratamiento = "Show Tratamiento"
    }
    override func viewDidLoad() {
    
        buttonCurrentAction?.backgroundColor = buttonCurrentAction?.backgroundColorDefault
        buttonNewAppointment?.backgroundColor = buttonNewAppointment?.backgroundColorDefault
        
    }
    
    @IBAction func showTratamiento(sender: CustomButton)
    {
        performSegueWithIdentifier(SegueIdentifier.IdentifierShowTratamiento, sender: sender)
    }
 
}
