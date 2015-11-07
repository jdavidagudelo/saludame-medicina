//
//  FormulaTableViewCell.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 5/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class FormulaTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonEdit: CustomButton!
    @IBOutlet weak var labelFormula: UILabel!{
        didSet{
            labelFormula?.text = formulaText
        }
    }
    
    var formula: Formula?{
        didSet{
            labelFormula?.text = formulaText
        }
    }
    private var formulaText : String{
        if formula != nil{
            return "Fórmula #: \(formula?.numero ?? "") - \(formula?.institucion ?? "")"
        }
        return ""
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
