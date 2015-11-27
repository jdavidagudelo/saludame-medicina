//
//  NotificationPreferencesViewController.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 18/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class NotificationPreferencesViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    private struct StoryBoard{
        static let PickProtocolPreferenceViewId = "PickProtocolPreferenceViewController"
        static let PickNicknamePreferenceViewId = "PickNicknameViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            let popover = pickNicknameViewController.popoverPresentationController
            popover?.delegate = self
            popover?.sourceView = sender
            self.presentViewController(pickNicknameViewController, animated: true, completion: nil)
        }
    }

}
