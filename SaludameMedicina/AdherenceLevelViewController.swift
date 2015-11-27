//
//  AdherenceLevelViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 21/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
import CoreData
class AdherenceLevelViewController: UIViewController, UITableViewDataSource{
    @IBInspectable
    var popoverHeight : CGFloat = CGFloat(200.0)
    @IBInspectable var imageLevelHigh: UIImage!
    @IBInspectable var imageLevelLow: UIImage!
    @IBInspectable var imageLevelAverage: UIImage!
    private var managedObjectContext: NSManagedObjectContext!
    
    var adherenceLevels = [(period: String?, levelImage: UIImage?, level: String?)](){
        didSet{
            tableView?.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        initLevels()
    }
    private func getImage(level: NSNumber) -> UIImage{
        if level == AdherenceLevel.Average{
            return imageLevelAverage
        }
        else if level == AdherenceLevel.High{
            return imageLevelHigh
        }
        return imageLevelLow
    }
    private func getLevelText(level: NSNumber) -> String?{
        if level == AdherenceLevel.Average{
            return NSLocalizedString("adherenceLevelAverage", tableName: "localization",comment: "Adherence level average")
        }
        else if level == AdherenceLevel.High{
            return NSLocalizedString("adherenceLevelHigh", tableName: "localization",comment: "Adherence level high")
        }
        return NSLocalizedString("adherenceLevelLow", tableName: "localization",comment: "Adherence level low")
    }
    private func initLevels(){
        let levelAWeekAgo = Evento.getAdherenceLevelCodeAWeekAgo(managedObjectContext)
        let levelToday = Evento.getAdherenceLevelCodeToday(managedObjectContext)
        let levelYesterday = Evento.getAdherenceLevelCodeYesterday(managedObjectContext)
        adherenceLevels = [(period: NSLocalizedString("periodToday", tableName: "localization",comment: "Period for today"),
            levelImage: getImage(levelToday), level: getLevelText(levelToday)),
            (period: NSLocalizedString("periodYesterday", tableName: "localization",comment: "Period for yesterday"),
                levelImage: getImage(levelYesterday), level: getLevelText(levelYesterday)),
            (period: NSLocalizedString("periodLastWeek", tableName: "localization",comment: "Period for last week"),
                levelImage: getImage(levelAWeekAgo), level: getLevelText(levelAWeekAgo))]
    }
    
    @IBOutlet
    var tableView: UITableView!{
        didSet{
            tableView?.dataSource = self
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adherenceLevels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AdherenceLevelCell", forIndexPath: indexPath) as? AdherenceLevelCell
        cell?.adherenceLevel = adherenceLevels[indexPath.row]
        return cell!
    }
    @IBAction func cancel(sender: UIButton){
        dismissViewControllerAnimated(true, completion: nil)
    }
}
