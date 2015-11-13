//
//  ItemInfoViewCell.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 13/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class ItemInfoViewCell: UITableViewCell {
    @IBOutlet var mainView : UIView!{
        didSet{
            mainView?.backgroundColor = colorView
        }
    }
    var colorView: UIColor?{
        didSet{
            mainView?.backgroundColor = colorView
        }
    }
    @IBOutlet
    var labelTitle: UITextView!{
        didSet{
            labelTitle?.text = info?.title
            labelTitle?.sizeToFit()
        }
    }
    @IBOutlet
    var labelDescription: UITextView!{
        didSet{
            labelDescription?.text = info?.description
            labelDescription.sizeToFit()
        }
    }
    var info : (title: String?, description: String?)?{
        didSet{
            labelTitle?.text = info?.title
            labelDescription?.text = info?.description
            labelTitle?.sizeToFit()
            labelDescription.sizeToFit()
        }
    }
}
