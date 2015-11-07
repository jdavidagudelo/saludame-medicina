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
    var formula : Formula?
    weak var listFormulasViewController: ListFormulasViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    private struct SegueIdentifier{
        static let IdentifierEditFormula = "Edit Formula"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    @IBAction func showFormula(sender: UIButton){
        dismissViewControllerAnimated(true, completion: nil)
        listFormulasViewController?.showFormula(formula)
    }
    @IBAction func editFormula(sender: UIButton)
    {
        dismissViewControllerAnimated(true, completion: nil)
        listFormulasViewController?.currentFormula = formula
        listFormulasViewController?.performSegueWithIdentifier(SegueIdentifier.IdentifierEditFormula, sender: sender)
    }
    @IBAction func deleteFormula(sender: UIButton)
    {
        dismissViewControllerAnimated(true, completion: nil)
        listFormulasViewController?.alertDeleteFormula(formula)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
