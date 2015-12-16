//
//  AboutViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 14/12/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var labelVersion: UILabel!{
        didSet{
            labelVersion?.text = appVersion
        }
    }
    var appVersion:String?{
        get{
            let nsObject: AnyObject? = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"]
            let version = nsObject as? String
            return version
        }
    }
    
    
}
