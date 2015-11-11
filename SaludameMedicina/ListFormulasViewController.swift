//
//  ListFormulasViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 4/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
import CoreData
@IBDesignable
class ListFormulasViewController: UIViewController, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    @IBInspectable
    var colorQuickAction : UIColor!
    @IBOutlet var tableView: UITableView!{
        didSet{
            let separator = UIView(frame: CGRectZero)
            tableView?.dataSource = self
            tableView?.tableFooterView = separator
            tableView?.tableHeaderView = separator
        }
    }
    
    @IBOutlet weak var labelMenu: UILabel!
    private struct StoryBoard{
        static let FormulaItemOptionsViewId = "FormulaItemOptionsViewController"
        static let ViewFormulaId = "ViewFormulaViewController"
    }
    var currentFormula : Formula?
    var formulas = [Formula](){
        didSet{
            tableView?.reloadData()
        }
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    var managedObjectContext: NSManagedObjectContext!
    private struct SegueIdentifier{
        static let IdentifierCreateNewFormula = "Create New Formula"
        static let IdentifierEditFormula = "Edit Formula"
    }
    @IBAction func deleteAll(sender: UIButton)
    {
        let title = NSLocalizedString("deleteFormulasTitle", tableName: "localization",comment: "Warning title")
        let message = NSLocalizedString("deleteFormulasMessage", tableName: "localization", comment: "All formulas will be deleted warning")
        let cancelText = NSLocalizedString("deleteFormulasCancel", tableName: "localization", comment: "Cancel deleting formulas")
        let acceptText = NSLocalizedString("deleteFormulasAccept", tableName: "localization", comment: "Confirm delete all formulas")
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
    private func deleteAll(){
        for formula in formulas
        {
            Formula.delete(managedObjectContext, formula: formula)
        }
        formulas.removeAll()
        tableView?.reloadData()
    }
    func alertDeleteFormula(formula: Formula?)
    {
        let title = NSLocalizedString("deleteFormulaTitle", tableName: "localization",comment: "Warning title")
        let message = NSLocalizedString("deleteFormulaMessage", tableName: "localization", comment: "A formula will be deleted warning")
        let cancelText = NSLocalizedString("deleteFormulaCancel", tableName: "localization", comment: "Cancel deleting a formula")
        let acceptText = NSLocalizedString("deleteFormulaAccept", tableName: "localization", comment: "Confirm delete a formula")
        let alert = UIAlertController(title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: cancelText, style: UIAlertActionStyle.Cancel, handler: {
            (action: UIAlertAction!) in alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: acceptText, style: UIAlertActionStyle.Destructive, handler: {
            (action: UIAlertAction!) in self.deleteFormula(formula)
        }))        
        presentViewController(alert, animated: true, completion: nil)

    }
    private func deleteFormula(formula: Formula?) {
        if let f = formula
        {
            if let index = formulas.indexOf(f)
            {
                formulas.removeAtIndex(index)
            }
        }
        if formula != nil{
            Formula.delete(managedObjectContext, formula: formula!)
        }
        tableView?.reloadData()
    }
    @IBAction func showCreateIdentifier(sender: UIButton)
    {
        performSegueWithIdentifier(SegueIdentifier.IdentifierCreateNewFormula, sender: sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        fetchFormulas()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView?.reloadData()
        fetchFormulas()
    }
    func fetchFormulas(){
        let fetchRequest = NSFetchRequest(entityName: "Formula")
        do{
            if let fetchResults = try managedObjectContext!.executeFetchRequest(fetchRequest) as? [Formula] {
                formulas = fetchResults
            }
        }
        catch {
            print(error)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return formulas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FormulaCell", forIndexPath: indexPath) as? FormulaTableViewCell
        cell?.formula = formulas[indexPath.row]
        cell?.buttonEdit.tag = indexPath.row
        cell?.buttonEdit.addTarget(self, action: "showEditView:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell!
    }
    func showFormula(formula: Formula?){
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let viewFormulaViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.ViewFormulaId) as? ViewFormulaViewController)
        {
            viewFormulaViewController.formula = formula
            viewFormulaViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            let popover = viewFormulaViewController.popoverPresentationController
            popover?.delegate = self
            popover?.sourceView = labelMenu
            popover?.sourceRect = CGRect(x: view.center.x, y: 0, width: 0, height: 0)
            popover?.backgroundColor = UIColor.clearColor()
            self.presentViewController(viewFormulaViewController, animated: true, completion: nil)
        }
    }
    func showEditView(sender: UIButton)
    {
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let editItemViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.FormulaItemOptionsViewId) as? FormulaItemOptionsViewController)
        {
            
            editItemViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            editItemViewController.formula = formulas[sender.tag]
            editItemViewController.listFormulasViewController = self
            let popover = editItemViewController.popoverPresentationController
            popover?.delegate = self
            popover?.permittedArrowDirections = [.Up, .Down]
            popover?.sourceView = sender
            popover?.sourceRect = sender.bounds
            popover?.backgroundColor = colorQuickAction
            self.presentViewController(editItemViewController, animated: true, completion: nil)
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as UIViewController
        if let createFormulaViewController = destination as? CreateFormulaViewController
        {
            createFormulaViewController.formula = currentFormula
            currentFormula = nil
        }
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
