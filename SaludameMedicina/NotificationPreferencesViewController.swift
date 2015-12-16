//
//  NotificationPreferencesViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 18/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class NotificationPreferencesViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    @IBOutlet var labelProtocol: UILabel!{
        didSet{
            let currentProtocol : NSNumber! = (NSUserDefaults.standardUserDefaults().objectForKey(NotificationPreferences.ProtocolPreferenceKey) as? NSNumber)
            var protocolText : String? = ""
            if currentProtocol != nil{
                switch currentProtocol{
                    case Protocol.Formal:
                        protocolText = Protocol.FormalText
                case Protocol.Informal:
                    protocolText = Protocol.InformalText
                case Protocol.Neutral:
                    protocolText = Protocol.NeutralText
                default: break
                }
            }
            else{
                protocolText = Protocol.FormalText
            }
            labelProtocol?.text = protocolText
        }
    }
    @IBOutlet var labelNickname: UILabel!{
        didSet{
            labelNickname?.text = (NSUserDefaults.standardUserDefaults().objectForKey(NotificationPreferences.NicknamePreferenceKey) as? String) ?? ""
        }
    }
    func saveProtocol(protocolText : String?){
        labelProtocol?.text = protocolText
    }
    func saveNickname(nickname: String?){
        labelNickname?.text = nickname
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func showProtocolPicker(sender: UIButton)
    {
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let pickProtocolPreferenceViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.PickProtocolPreferenceViewId) as? PickProtocolPreferenceViewController)
        {
            pickProtocolPreferenceViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            pickProtocolPreferenceViewController.saveProtocol = saveProtocol
            let popover = pickProtocolPreferenceViewController.popoverPresentationController
            popover?.delegate = self
            popover?.sourceView = sender
            self.presentViewController(pickProtocolPreferenceViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func showNicknamePicker(sender: UIButton)
    {
        let mainStoryboardId = UIStoryboard(name: "Main", bundle: nil)
        if let pickNicknameViewController = (mainStoryboardId.instantiateViewControllerWithIdentifier(StoryBoard.PickNicknamePreferenceViewId) as? PickNicknameViewController)
        {
            pickNicknameViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            pickNicknameViewController.saveNickname = saveNickname
            let popover = pickNicknameViewController.popoverPresentationController
            popover?.delegate = self
            popover?.sourceView = sender
            self.presentViewController(pickNicknameViewController, animated: true, completion: nil)
        }
    }

}
