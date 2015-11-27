//
//  CustomButtonCell.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 27/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class CustomButtonCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!{
        didSet{
            labelTitle?.text = information?.title
        }
    }
    @IBOutlet weak var labelDescription: UILabel!{
        didSet{
            labelDescription?.text = information?.description
        }
    }
    @IBOutlet weak var imageViewIcon: UIImageView!{
        didSet{
            imageViewIcon?.image = information?.icon
        }
    }
    @IBAction func executeAction(sender: UIButton){
        information?.action?(sender: sender)
    }
    var information : (title: String?, description: String?, icon: UIImage?, action: ((sender: UIButton) -> Void)?)?{
        didSet{
            labelTitle?.text = information?.title
            labelDescription?.text = information?.description
            imageViewIcon?.image = information?.icon
        }
    }
}
