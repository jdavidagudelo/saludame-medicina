//
//  ViewFormulaViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 7/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
@IBDesignable
class ViewFormulaViewController: UIViewController {
    @IBInspectable
    var popoverHeight: CGFloat = 300
    var formula : Formula?{
        didSet{
            labelRecommendations?.text = formula?.recomendaciones
            labelFormulaNumber?.text = formula?.numero
            labelInstitution?.text = formula?.institucion
            labelFormulaDate?.text = formattedDate
        }
    }
    var formattedDate: String{
        get
        {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd-M-yyyy"
            if let date = (formula?.fecha){
                return formatter.stringFromDate(date)
            }
            return ""
        }
    }
    override var preferredContentSize: CGSize {
        get{
            if  presentingViewController != nil {
                return CGSize(width: super.preferredContentSize.width, height: popoverHeight)
            }
            else{
                return super.preferredContentSize
            }
        }
        set{super.preferredContentSize = newValue}
    }
    @IBOutlet weak var labelRecommendations: UILabel!{
        didSet{
            labelRecommendations?.text = formula?.recomendaciones
        }
    }
    @IBOutlet weak var labelFormulaDate: UILabel!{
        didSet{
            labelFormulaDate?.text = formattedDate
        }
    }
    @IBOutlet weak var labelFormulaNumber: UILabel!{
        didSet{
            labelFormulaNumber?.text = formula?.numero
        }
    }
    @IBOutlet weak var labelInstitution: UILabel!{
        didSet{
            labelInstitution?.text = formula?.institucion
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeView(sender: UIButton) {
        dismissViewControllerAnimated(true, completion : nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
