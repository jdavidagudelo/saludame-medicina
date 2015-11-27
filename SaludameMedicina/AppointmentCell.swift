//
//  AppointmentCell.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 26/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class AppointmentCell: UITableViewCell {
    @IBOutlet weak var labelDate: UILabel!{
        didSet{
            if let date = appointment?.date{
                labelDate?.text = TimeUtil.getDateFormatted(date)
            }
        }
    }
    @IBOutlet weak var labelTime: UILabel!{
        didSet{
            if let date = appointment?.date{
                labelTime?.text = TimeUtil.getTimeFormatted(date)
            }
        }
    }
    @IBOutlet weak var buttonEdit: UIButton!
    var appointment: Appointment?{
        didSet{
            if let date = appointment?.date {
                labelDate?.text = TimeUtil.getDateFormatted(date)
                labelTime?.text = TimeUtil.getTimeFormatted(date)
            }
        }
    }
}
