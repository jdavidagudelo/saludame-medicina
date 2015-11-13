//
//  ViewFormulaViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 7/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
@IBDesignable
class ViewFormulaViewController: UIViewController, UITableViewDataSource {
    @IBInspectable
    var popoverHeight: CGFloat = 300
    @IBInspectable
    var colorCellEven : UIColor?
    @IBInspectable
    var colorCellOdd : UIColor?
    var formulaData = [(title: String?, description: String?)](){
        didSet{
            tableView?.reloadData()
        }
    }
    @IBOutlet
    var tableView: UITableView!{
        didSet{
            tableView.estimatedRowHeight = tableView.rowHeight
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView?.dataSource = self
            tableView?.reloadData()
        }
    }
    var formula : Formula?{
        didSet{
            initData()
        }
    }
    var formattedDate: String?{
        get
        {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            if let date = (formula?.fecha){
                return formatter.stringFromDate(date)
            }
            return ""
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeView(sender: UIButton) {
        dismissViewControllerAnimated(true, completion : nil)
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return formulaData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FormulaItemInfoCell", forIndexPath: indexPath) as? ItemInfoViewCell
        cell?.info = formulaData[indexPath.row]
        //IOS BUG
        cell?.contentView.frame = (cell?.bounds)!;
        cell?.contentView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight];
        if indexPath.row%2 == 0{
            cell?.colorView = colorCellEven
        }
        else{
            cell?.colorView = colorCellOdd
        }
        return cell!
    }
    private func initData(){
        var currentFormulaData = [(title: String?, description: String?)]()
        currentFormulaData += [(title: Optional(NSLocalizedString("institutionFormulaTitle", tableName: "localization",comment: "Institution of fórmula title")),
            description: formula?.institucion)]
        currentFormulaData += [(title: Optional(NSLocalizedString("numberFormulaTitle", tableName: "localization",comment: "Number of formula title")),
            description: formula?.numero)]
        currentFormulaData += [(title: Optional(NSLocalizedString("dateFormulaTitle", tableName: "localization",comment: "Date of formula title")),
            description: formattedDate)]
        currentFormulaData += [(title: Optional(NSLocalizedString("dateFormulaRecommendationsTitle", tableName: "localization",comment: "Recommendations of formula title")),
            description: formula?.recomendaciones)]
        formulaData = currentFormulaData
        
    }
}
