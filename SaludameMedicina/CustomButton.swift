//
//  CustomButton.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 26/10/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
@IBDesignable
class CustomButton: UIButton {
    @IBInspectable
    var backgroundColorDefault: UIColor!{
        didSet{
            if !highlighted{
                backgroundColor = backgroundColorDefault
            }
        }
    }
    @IBInspectable
    var imageNormal: UIImage? = nil{
        didSet{
            if imageNormal != nil{
                setBackgroundImage(imageNormal, forState: UIControlState.Normal)
            }
        }
    }
    @IBInspectable
    var imagePressed: UIImage? = nil{
        didSet{
            if imagePressed != nil{
                setBackgroundImage(imagePressed, forState: UIControlState.Highlighted)
            }
        }
    }
    @IBInspectable
    var borderWidth : CGFloat = 1{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable
    var cornerRadius : CGFloat = 5{
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable
    var borderColor: UIColor = UIColor.blackColor() {
        didSet{
            layer.borderColor = borderColor.CGColor
        }
    }

    @IBInspectable
    var backgroundColorHighLigthed: UIColor!{
        didSet{
            if highlighted{
                backgroundColor = backgroundColorHighLigthed
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override var highlighted: Bool {
        get {
            return super.highlighted
        }
        set {
            if newValue {
                backgroundColor = backgroundColorHighLigthed
            }
            else {
                backgroundColor = backgroundColorDefault
            }
            super.highlighted = newValue
        }
    }
}
