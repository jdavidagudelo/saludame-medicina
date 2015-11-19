//
//  DelayIntervalCell.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 19/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class DelayIntervalCell: UITableViewCell {
    @IBOutlet var switchSelectItem: UISwitch!{
        didSet{
            switchSelectItem?.on = value ?? false
        }
    }
    @IBOutlet var labelText: UILabel!{
        didSet{
            labelText?.text = currentText
        }
    }
    var value: Bool?{
        didSet{
            switchSelectItem?.on = value ?? false
        }
    }
    var currentText: String?{
        didSet{
            labelText?.text = currentText
        }
    }
}
