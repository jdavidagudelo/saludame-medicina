//
//  AdherenceLevelCell.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 21/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class AdherenceLevelCell: UITableViewCell {
    var adherenceLevel : (period: String?, levelImage: UIImage?, level: String?)?{
        didSet{
            imageViewAdherenceLevel?.image = adherenceLevel?.levelImage
            labelPeriod?.text = adherenceLevel?.period
            labelLevel?.text = adherenceLevel?.level
        }
    }
    @IBOutlet var imageViewAdherenceLevel: UIImageView!{
        didSet{
            imageViewAdherenceLevel?.image = adherenceLevel?.levelImage
        }
    }
    @IBOutlet var labelPeriod: UILabel!{
        didSet{
            labelPeriod?.text = adherenceLevel?.period
        }
    }
    @IBOutlet var labelLevel: UILabel!{
        didSet{
            labelLevel?.text = adherenceLevel?.level
        }
    }
    
}
