//
//  CustomToastUIViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 11/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
@IBDesignable
class CustomToastUIViewController: UIViewController {
    @IBInspectable
    var popoverHeight : CGFloat = CGFloat(90.0)
    @IBInspectable
    var popoverWidth  : CGFloat = CGFloat(100.0)
    
    var delay : Int = 5 {
        didSet{
        }
    }
    @IBOutlet weak var labelText : UITextView!{
        didSet{
            labelText?.text = currentText
        }
    }
    @IBInspectable
    var currentText : String? = ""{
        didSet{
            labelText?.text = currentText
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let d = Double(delay) * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(d))
        dispatch_after(time, dispatch_get_main_queue()){ self.dismissViewControllerAnimated(true, completion: nil)}
    }
    override var preferredContentSize: CGSize {
        get{
            if labelText != nil && presentingViewController != nil {
                let size = labelText.sizeThatFits((presentingViewController?.view?.bounds.size)!)
                return CGSize(width: size.width, height: size.height+20)
            }
            else{
                return super.preferredContentSize
            }
        }
        set{super.preferredContentSize = newValue}
    }
    
}
