//
//  PickNicknameViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 18/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class PickNicknameViewController: UIViewController {
    @IBInspectable
    var popoverHeight : CGFloat = CGFloat(200.0)
    var saveNickname: ((String?) -> Void)?
    @IBOutlet var textFieldNickname: UITextField!{
        didSet{
            textFieldNickname?.text = (NSUserDefaults.standardUserDefaults().objectForKey(NotificationPreferences.NicknamePreferenceKey) as? String) ?? ""
        }
    }
    @IBAction func save(sender: UIButton){
        NSUserDefaults.standardUserDefaults().setObject(textFieldNickname?.text, forKey: NotificationPreferences.NicknamePreferenceKey)
        dismissViewControllerAnimated(true, completion: nil)
        saveNickname?(textFieldNickname?.text)
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
    
    @IBAction func cancel(sendet: UIButton){
        dismissViewControllerAnimated(true, completion: nil)
    }
}
