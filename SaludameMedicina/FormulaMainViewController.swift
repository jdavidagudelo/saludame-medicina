//
//  FormulaMainViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 4/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class FormulaMainViewController: UIViewController {

    private struct SegueIdentifier{
        static let IdentifierShowFormulas = "Show List Formulas"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func showFormulas(sender: UIButton)
    {
        performSegueWithIdentifier(SegueIdentifier.IdentifierShowFormulas, sender: sender)
    }

}
