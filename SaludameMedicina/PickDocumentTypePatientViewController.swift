//
//  PickDocumentTypePatientViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 13/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit
@IBDesignable
class PickDocumentTypePatientViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    var patientInfoViewController: PatientInfoViewController?
    @IBInspectable
    var popoverHeight : CGFloat = CGFloat(200.0)
    var documentType :String?{
        didSet{
            selectDocumentType(documentType)
        }
    }
    private func selectDocumentType(documentType: String?){
        if let d = documentType{
            if let index = documentTypes.indexOf(d)
            {
                pickerIdentificationType?.selectRow(index, inComponent: 0, animated: true)
            }
        }
    }
    var documentTypes = [String](){
        didSet{
            pickerIdentificationType?.reloadAllComponents()
            selectDocumentType(documentType)
        }
    }
    @IBOutlet
    weak var pickerIdentificationType: UIPickerView!{
        didSet{
            pickerIdentificationType?.dataSource = self
            pickerIdentificationType?.delegate = self
            
        }
    }
    private func initIntervals(){
        documentTypes = [IdentificationType.Cedula, IdentificationType.CedulaExtrajeria,
            IdentificationType.Pasaporte, IdentificationType.IdentityCard]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initIntervals()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return documentTypes.count
    }
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        let text = documentTypes[row]
        let label = UILabel()
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        label.text = text
        return label
    }
    @IBAction func cancel(sender: UIButton){
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func saveDocumentType(sender: UIButton){
        let documentType = documentTypes[pickerIdentificationType.selectedRowInComponent(0)]
        patientInfoViewController?.identificationType = documentType
        dismissViewControllerAnimated(true, completion: nil)
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
}
