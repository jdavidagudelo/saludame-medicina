//
//  FormulaItemOptionsViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 6/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
@IBDesignable
class FormulaItemOptionsViewController: UIViewController {
    @IBInspectable
    var popoverHeight : CGFloat = CGFloat(90.0)
    @IBInspectable
    var popoverWidth  : CGFloat = CGFloat(100.0)
    var formula : Formula?
    var sender: UIView?
    weak var listFormulasViewController: ListFormulasViewController?
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
    @IBAction func showFormula(sender: UIButton){
        dismissViewControllerAnimated(true, completion: nil)
        if let senderView = self.sender{
            listFormulasViewController?.showFormula(formula, sender: senderView)
        }
        
    }
    @IBAction func editFormula(sender: UIButton)
    {
        dismissViewControllerAnimated(true, completion: nil)
        listFormulasViewController?.currentFormula = formula
        listFormulasViewController?.showEditFormula()
    }
    @IBAction func deleteFormula(sender: UIButton)
    {
        dismissViewControllerAnimated(true, completion: nil)
        listFormulasViewController?.alertDeleteFormula(formula)
    }

}
