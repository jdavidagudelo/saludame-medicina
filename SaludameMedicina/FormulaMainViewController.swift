//
//  FormulaMainViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 4/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class FormulaMainViewController: UIViewController, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        initCustomButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func showFormulas(sender: UIButton)
    {
        performSegueWithIdentifier(SegueIdentifier.IdentifierShowListFormulas, sender: sender)
    }
    var customButtons : [(title: String?, description: String?, icon: UIImage?, action: ((sender: UIButton) -> Void)?)]?{
        didSet{
            tableView?.reloadData()
        }
    }
    @IBInspectable var iconFormula: UIImage?
    @IBOutlet var tableView: UITableView!{
        didSet{
            tableView?.dataSource = self
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return customButtons?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FormulaCustomButtonCell", forIndexPath: indexPath) as? CustomButtonCell
        cell?.information = customButtons?[indexPath.row]
        cell?.backgroundColor = UIColor.clearColor()
        return cell!
    }
 
    private func initCustomButtons(){
        var currentCustomButtons : [(title: String?, description: String?, icon: UIImage?, action: ((sender: UIButton) -> Void)?)]
        currentCustomButtons = []
        let formulasTitle: String? = NSLocalizedString("registerFormulasTitle", tableName: "localization",
            comment: "Register Formulas Title")
        let formulasDescription: String? = NSLocalizedString("registerFormulasDescription", tableName: "localization",
            comment: "Register Formulas Description")
        let actionFormula : ((sender: UIButton) -> Void)? = showFormulas
        currentCustomButtons += [(title: formulasTitle, description: formulasDescription, icon: iconFormula, action: actionFormula)]
        customButtons = currentCustomButtons
        
    }
}
