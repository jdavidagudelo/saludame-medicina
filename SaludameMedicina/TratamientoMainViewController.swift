//
//  TratamientoMainViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 4/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class TratamientoMainViewController: UIViewController {
    private struct SegueIdentifier{
        static let IdentifierShowFormulas = "Show Formulas"
        static let IdentifierShowMedicamentos = "Show Medicamentos"
        static let IdentifierMedicationSchedule = "Show Medication Schedule"
    }
    @IBAction func showMedicationSchedule(sender: UIButton){
        performSegueWithIdentifier(SegueIdentifier.IdentifierMedicationSchedule, sender: sender)
    }
    @IBAction func showFormulas(sender: UIButton){
        performSegueWithIdentifier(SegueIdentifier.IdentifierShowFormulas, sender: sender)
    }
    @IBAction func showMedicamentos(sender: UIButton)
    {
        performSegueWithIdentifier(SegueIdentifier.IdentifierShowMedicamentos, sender: sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
