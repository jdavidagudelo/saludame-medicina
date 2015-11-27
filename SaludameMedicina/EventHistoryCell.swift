//
//  EventHistoryCell.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 26/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class EventHistoryCell: UITableViewCell {
    var event: Evento?{
        didSet{
            labelName?.text = event?.nameText
            labelDate?.text = event?.dateText
        }
    }
    @IBOutlet var buttonEdit: UIButton!
    @IBOutlet var imageViewState: UIImageView!{
        didSet{
            imageViewState?.image = imageState
        }
    }
    var imageState: UIImage?{
        didSet{
            imageViewState?.image = imageState
        }
    }
    @IBOutlet var labelName: UILabel!{
        didSet{
            labelName?.text = event?.nameText
        }
    }
    @IBOutlet var labelDate: UILabel!{
        didSet{
            labelDate?.text = event?.dateText
        }
    }
}
