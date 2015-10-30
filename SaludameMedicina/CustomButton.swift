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
    var borderColor = UIColor.blackColor().CGColor{
        didSet{
            layer.borderColor = borderColor
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
        self.backgroundColor = backgroundColorDefault
        self.setNeedsDisplay()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor
        backgroundColor = backgroundColorDefault
        highlighted = false
        titleLabel?.numberOfLines = 0
        self.setNeedsDisplay()
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
