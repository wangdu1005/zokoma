//
//  AboutViewController.swift
//  Zokoma
//
//  Created by jiro9611 on 12/8/15.
//  Copyright © 2015 jiro9611. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseAnalytics

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAnalytics.logEvent(withName: "view_item", parameters: [
            "item_name": "AboutMeScreenView" as NSObject
            ])

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendEmail (_ sender: AnyObject) {
        
        FIRAnalytics.logEvent(withName: "sendEmail", parameters: [
            "email": "wangdu1005@gmail.com" as NSObject,
            "content_type": "sedn_email_category" as NSObject,
            "item_id": "sendEmailAction" as NSObject
            ])
        
        print("Contact US Button Clicked")
        
        if MFMailComposeViewController.canSendMail() {
            let composer = MFMailComposeViewController()
            
            composer.mailComposeDelegate = self
            composer.setToRecipients(["zokoma.service@gmail.com"])
            composer.navigationBar.tintColor = UIColor.white
            
            present(composer, animated: true, completion: {
                
//                UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
                
                //setStatusBarStyle:UIStatusBarStyleLightContent];
                
            })
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
            
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
            
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
            
        case MFMailComposeResult.failed.rawValue:
            print("Failed to send mail: \(error?.localizedDescription)")
            
        default:
            break
        }
        
        // Dismiss the Mail interface
        dismiss(animated: true, completion: nil)
    }
    
    

    @IBAction func visitWebSite(_ sender: AnyObject) {
        
        FIRAnalytics.logEvent(withName: "select_content", parameters: [
            "content_type": "Website" as NSObject,
            "item_id": "visit_official_website" as NSObject
            ])
    
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
