//
//  MedicamentoTableViewCell.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 11/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class MedicamentoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var buttonEdit: UIButton!
    var medicamento: Medicamento?{
        didSet{
            labelMedicamento?.text = Medicamento.getText(medicamento)
        }
    }
    @IBOutlet weak var labelMedicamento: UILabel!{
        didSet{
            labelMedicamento?.text = Medicamento.getText(medicamento)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
