//
//  EventsHeaderCell.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 22/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class EventsHeaderCell: UITableViewCell {
    @IBOutlet var labelMedication: UILabel!{
        didSet{
            labelMedication?.text = medication?.nombre
        }
    }
    @IBOutlet weak var buttonState: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var buttonOpen: UIButton!
    @IBOutlet weak var imageViewOpen: UIImageView!{
        didSet{
            imageViewOpen?.image = imageOpen
        }
    }
    @IBOutlet weak var imageViewState: UIImageView?{
        didSet{
            imageViewState?.image = imageState
        }
    }
    var imageOpen: UIImage?{
        didSet{
            if imageOpen != nil{
                imageViewOpen?.image = imageOpen
            }
        }
    }
    var imageState: UIImage?{
        didSet{
            if imageState != nil{
                imageViewState?.image = imageState
            }
        }
    }
    var medication: Medicamento?{
        didSet{
            labelMedication?.text = medication?.nombre
        }
    }
}
