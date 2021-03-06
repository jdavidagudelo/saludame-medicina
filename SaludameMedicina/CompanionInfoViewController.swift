//
//  CompanionInfoViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 17/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class CompanionInfoViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textFieldName: UITextField!{
        didSet{
            textFieldName?.delegate = self
            textFieldName?.text = (NSUserDefaults.standardUserDefaults().objectForKey(CompanionPreferences.Name) as? String) ?? ""
        }
    }
    func textViewDidEndEditing(textView: UITextView) {
        textView.resignFirstResponder()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField{
        case textFieldName:
            textFieldCellPhone?.becomeFirstResponder()
        case textFieldCellPhone:
            textFieldEmail?.becomeFirstResponder()
        default: break
        }
        return true
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        let view = labelsMap[textField]
        let scrollPoint = CGPointMake(0, view?.frame.origin.y ?? 0)
        scrollView?.setContentOffset(scrollPoint, animated: true)
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initLabels()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    private func initLabels(){
        labelsMap = [textFieldName: labelName, textFieldCellPhone: labelMobile, textFieldEmail: labelEmail]
    }
    private var labelsMap = [UIView: UILabel]()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textFieldCellPhone: UITextField!{
        didSet{
            textFieldCellPhone?.delegate = self
            textFieldCellPhone?.text = (NSUserDefaults.standardUserDefaults().objectForKey(CompanionPreferences.Cellphone) as? String) ?? ""
        }
    }
    @IBOutlet weak var textFieldEmail: UITextField!{
        didSet{
            textFieldEmail?.delegate = self
            textFieldEmail?.text = (NSUserDefaults.standardUserDefaults().objectForKey(CompanionPreferences.Email) as? String) ?? ""
        }
    }
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelMobile: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBAction func cancel(sender: UIButton){
        navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func save(sender: UIButton){
        if (textFieldName?.text?.isEmpty ?? true) {
            labelName?.textColor = UIColor.redColor()
            return
        }
        NSUserDefaults.standardUserDefaults().setObject(textFieldName?.text, forKey: CompanionPreferences.Name)
        NSUserDefaults.standardUserDefaults().setObject(textFieldCellPhone?.text, forKey: CompanionPreferences.Cellphone)
        NSUserDefaults.standardUserDefaults().setObject(textFieldEmail?.text, forKey: CompanionPreferences.Email)
        navigationController?.popViewControllerAnimated(true)
    }
}
