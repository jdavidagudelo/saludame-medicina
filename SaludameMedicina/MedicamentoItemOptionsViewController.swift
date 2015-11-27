//
//  MedicamentoItemOptionsViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 11/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
@IBDesignable
class MedicamentoItemOptionsViewController: UIViewController {
    
    @IBInspectable
    var popoverHeight : CGFloat = CGFloat(90.0)
    @IBInspectable
    var popoverWidth  : CGFloat = CGFloat(100.0)
    var medicamento : Medicamento?
    var sender: UIView?
    weak var listMedicamentosViewController : ListMedicamentosViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    private struct SegueIdentifier{
        static let IdentifierEditMedicamento = "Edit Medicamento"
        static let IdentifierScheduleMedication = "Show Schedule"
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
   @IBAction func showMedication(sender: UIButton){
        dismissViewControllerAnimated(true, completion: nil)
        if let senderView = self.sender{
            listMedicamentosViewController?.showMedication(medicamento, sender: senderView)
        }
    }
    @IBAction func editMedicamento(sender: UIButton)
    {
        dismissViewControllerAnimated(true, completion: nil)
        listMedicamentosViewController?.currentMedicamento = medicamento
        listMedicamentosViewController?.performSegueWithIdentifier(SegueIdentifier.IdentifierEditMedicamento, sender: sender)
    }
    @IBAction func showSchedule(sender: UIButton){
        dismissViewControllerAnimated(true, completion: nil)
        listMedicamentosViewController?.currentMedicamento = medicamento
        listMedicamentosViewController?.performSegueWithIdentifier(SegueIdentifier.IdentifierScheduleMedication, sender: sender)
    }
    @IBAction func deleteMedicamento(sender: UIButton)
    {
        dismissViewControllerAnimated(true, completion: nil)
        listMedicamentosViewController?.alertDeleteMedicamento(medicamento)
    }

}
