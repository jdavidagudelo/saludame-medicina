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
    override func viewDidLoad() {
    
        buttonCurrentAction?.backgroundColor = buttonCurrentAction?.backgroundColorDefault
        buttonNewAppointment?.backgroundColor = buttonNewAppointment?.backgroundColorDefault
    }
    @IBAction func showTratamiento(sender: CustomButton)
    {
        let tratamientoStoryboardId = UIStoryboard(name: "Tratamiento", bundle: nil)
        let tratamientoViewController = tratamientoStoryboardId.instantiateViewControllerWithIdentifier("TratamientoStoryboard") as? TratamientoMainViewController
        presentViewController(tratamientoViewController!, animated: true, completion: nil)
    }
}
