//
//  ViewMedicationViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 13/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class ViewMedicationViewController: UIViewController, UITableViewDataSource {
    @IBInspectable
    var popoverHeight: CGFloat = 300
    @IBInspectable
    var colorCellEven : UIColor?
    @IBInspectable
    var colorCellOdd : UIColor?
    var medication: Medicamento?{
        didSet{
            initData()
        }
    }
    var medicationData = [(title: String?, description: String?)](){
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
        return medicationData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MedicamentoItemInfoCell", forIndexPath: indexPath) as? ItemInfoViewCell
        cell?.info = medicationData[indexPath.row]
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
    
    private func formattedDate(date: NSDate?) -> String?{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        if let d = date{
            return formatter.stringFromDate(d)
        }
        return ""
    }
    private func initData(){
        var currentMedicationData = [(title: String?, description: String?)]()
        currentMedicationData += [(title: Optional(NSLocalizedString("nameMedicationTitle", tableName: "localization",comment: "Name of medication title")),
            description: medication?.nombre)]
        currentMedicationData += [(title: Optional(NSLocalizedString("presentationMedicationTitle", tableName: "localization",comment: "Presentation of medication title")),
            description: medication?.presentacion)]
        currentMedicationData += [(title: Optional(NSLocalizedString("quantityMedicationTitle", tableName: "localization",comment: "QUantity of a medication title")),
            description: Optional("\(medication?.dosis ?? 0)"))]
        currentMedicationData += [(title: Optional(NSLocalizedString("periodMedicationTitle", tableName: "localization",comment: "Period of a medication title")),
            description: Optional("\(medication?.periodicidad ?? 0) \(medication?.unidadTiempoPeriodicidad ?? "")"))]
        currentMedicationData += [(title: Optional(NSLocalizedString("durationMedicationTitle", tableName: "localization",comment: "Duration of medication title")),
            description: Optional("\(medication?.duracion ?? 0) \(IntervalConstants.DaysInterval)"))]
        currentMedicationData += [(title: Optional(NSLocalizedString("startDateMedicationTitle", tableName: "localization",comment: "Start date of medication title")),
            description: formattedDate(medication?.fechaInicio ?? NSDate()))]
        currentMedicationData += [(title: Optional(NSLocalizedString("endDateMedicationTitle", tableName: "localization",comment: "End date of medication title")),
            description: formattedDate(medication?.fechaFin ?? NSDate()))]
        currentMedicationData += [(title: Optional(NSLocalizedString("recommendationsMedicationTitle", tableName: "localization",comment: "Recommendations of medication title")),
            description: medication?.indicaciones)]
        medicationData = currentMedicationData
        
    }
}
