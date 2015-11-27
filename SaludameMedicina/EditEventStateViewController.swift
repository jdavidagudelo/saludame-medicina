//
//  EditEventStateViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 23/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
import CoreData
class EditEventStateViewController: UIViewController {
    @IBInspectable
    var popoverHeight: CGFloat = 300
    var managedObjectContext: NSManagedObjectContext!
    var event: Evento?
    var reload: (() -> Void)?
    @IBAction func rejectEvent(sender: UIButton){
        Evento.setAnswer(managedObjectContext, event: event, answer: EventAnswer.Rejected)
        reload?()
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func acceptEvent(sender: UIButton){
        Evento.setAnswer(managedObjectContext, event: event, answer: EventAnswer.Accepted)
        reload?()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
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
}
