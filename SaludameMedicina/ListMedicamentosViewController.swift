//
//  ListMedicamentosViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 10/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
import CoreData

class ListMedicamentosViewController: UIViewController, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var labelMenu : UILabel!
    var managedObjectContext: NSManagedObjectContext!
    var currentMedicamento: Medicamento?
    @IBInspectable
    var colorQuickAction : UIColor!
    
  
    
    @IBOutlet
    weak var tableView : UITableView!{
        didSet{
            tableView?.dataSource = self
        }
    }
    var medicamentos  = [Medicamento](){
        didSet{
            tableView?.reloadData()
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return medicamentos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MedicamentoCell", forIndexPath: indexPath) as? MedicamentoTableViewCell
        cell?.medicamento = medicamentos[indexPath.row]
        cell?.buttonEdit.tag = indexPath.row
        cell?.buttonEdit.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
        cell?.buttonEdit.addTarget(self, action: "showEditView:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        fetchMedicamentos()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView?.reloadData()
        fetchMedicamentos()
    }
    @IBAction func showCreateTratamiento(sender: UIButton)
    {
        performSegueWithIdentifier(SegueIdentifier.IdentifierEditMedicamento, sender: sender)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func fetchMedicamentos(){
        let fetchRequest = NSFetchRequest(entityName: "Medicamento")
        do{
            if let fetchResults = try managedObjectContext!.executeFetchRequest(fetchRequest) as? [Medicamento] {
                medicamentos = fetchResults
            }
        }
        catch {
            print(error)
        }
    }
    
   
    func showEditView(sender: UIButton)
    {
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let editItemViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.MedicamentoItemOptionsViewId) as? MedicamentoItemOptionsViewController)
        {
            
            editItemViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            editItemViewController.medicamento = medicamentos[sender.tag]
            editItemViewController.listMedicamentosViewController = self
            editItemViewController.sender = sender
            let popover = editItemViewController.popoverPresentationController
            popover?.delegate = self
            popover?.permittedArrowDirections = [.Up, .Down]
            popover?.sourceView = sender
            popover?.sourceRect = sender.bounds
            popover?.backgroundColor = colorQuickAction
            self.presentViewController(editItemViewController, animated: true, completion: nil)
        }
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as UIViewController
        if let createMedicamentoViewController = destination as? CreateMedicamentoViewController
        {
            if segue.identifier == SegueIdentifier.IdentifierEditMedicamento{
                createMedicamentoViewController.medicamento = currentMedicamento
                currentMedicamento = nil
            }
        }
        if let scheduleViewController = destination as? ScheduleMedicationViewController{
            if segue.identifier == SegueIdentifier.IdentifierScheduleMedication{
                scheduleViewController.medicamento = currentMedicamento
                currentMedicamento = nil
            }
        }
    }
    
    private func deleteAll(){
        for medicamento in medicamentos
        {
            Medicamento.delete(managedObjectContext, medicamento: medicamento)
        }
        medicamentos.removeAll()
        tableView?.reloadData()
    }
    @IBAction func deleteAll(sender: UIButton)
    {
        let title = NSLocalizedString("deleteMedicationsTitle", tableName: "localization",comment: "Warning title")
        let message = NSLocalizedString("deleteMedicationsMessage", tableName: "localization", comment: "All medications will be deleted warning")
        let cancelText = NSLocalizedString("deleteMedicationsCancel", tableName: "localization", comment: "Cancel deleting medications")
        let acceptText = NSLocalizedString("deleteMedicationsAccept", tableName: "localization", comment: "Confirm delete all medications")
        let alert = UIAlertController(title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: cancelText, style: UIAlertActionStyle.Cancel, handler: {
            (action: UIAlertAction!) in alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: acceptText, style: UIAlertActionStyle.Destructive, handler: {
            (action: UIAlertAction!) in self.deleteAll()
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    private func deleteMedicamento(medicamento: Medicamento?) {
        if let m = medicamento
        {
            if let index = medicamentos.indexOf(m)
            {
                medicamentos.removeAtIndex(index)
            }
        }
        if medicamento != nil{
            Medicamento.delete(managedObjectContext, medicamento: medicamento!)
        }
        tableView?.reloadData()
    }
    func alertDeleteMedicamento(medicamento: Medicamento?)
    {
        let title = NSLocalizedString("deleteMedicationTitle", tableName: "localization", comment: "Warning title")
        let message = NSLocalizedString("deleteMedicationMessage", tableName: "localization", comment: "A medication will be deleted warning")
        let cancelText = NSLocalizedString("deleteMedicationCancel", tableName: "localization", comment: "Cancel deleting a medication")
        let acceptText = NSLocalizedString("deleteMedicationAccept", tableName: "localization", comment: "Confirm delete a medication")
        let alert = UIAlertController(title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: cancelText, style: UIAlertActionStyle.Cancel, handler: {
            (action: UIAlertAction!) in alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: acceptText, style: UIAlertActionStyle.Destructive, handler: {
            (action: UIAlertAction!) in self.deleteMedicamento(medicamento)
        }))
        presentViewController(alert, animated: true, completion: nil)
        
    }
    func showMedication(medication: Medicamento?, sender: UIView){
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let viewMedicationViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.ViewMedicationId) as? ViewMedicationViewController)
        {
            viewMedicationViewController.medication = medication
            viewMedicationViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            let popover = viewMedicationViewController.popoverPresentationController
            popover?.delegate = self
            popover?.sourceView = sender
            popover?.backgroundColor = UIColor.whiteColor()
            self.presentViewController(viewMedicationViewController, animated: true, completion: nil)
        }
    }
}
