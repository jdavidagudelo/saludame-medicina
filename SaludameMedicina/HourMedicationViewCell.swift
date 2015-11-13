//
//  HourMedicationViewCell.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 12/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class HourMedicationViewCell: UITableViewCell {
    var dateText: String?{
        didSet{
            labelDate?.text = dateText
        }
    }
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var labelDate: UILabel!{
        didSet{
            labelDate?.text = dateText
        }
    }
    
    
}
