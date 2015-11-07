//
//  CustomTextField.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 5/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {
    @IBInspectable
    var cornerRadius: CGFloat = 5{
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable
    var borderColor: UIColor! {
        didSet{
            layer.borderColor = borderColor?.CGColor
        }
    }
    @IBInspectable
    var borderWidth: CGFloat = 1{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
