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
        
//        FIRAnalytics.logEventWithName("sendEmail", parameters: [
////            "email": "wangdu1005@gmail.com"
//            "content_type": "sedn_email_category",
//            "item_id": "sendEmailAction"
//            ])
        
        print("Contact US Button Clicked")
//        if MFMailComposeViewController.canSendMail() {
//            let composer = MFMailComposeViewController()
//            composer.mailComposeDelegate = self
//            composer.setToRecipients(["jiro.lin9611@gmail.com"])
//            composer.navigationBar.tintColor = UIColor.whiteColor()
//            presentViewController(composer, animated: true, completion: {
//                UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
//            })
//        }
        
        if MFMailComposeViewController.canSendMail() {
            let composer = MFMailComposeViewController()
            
            composer.mailComposeDelegate = self
            composer.setToRecipients(["zokoma.service@gmail.com"])
            composer.navigationBar.tintColor = UIColor.white
            
            //            presentViewController(composer, animated: true, completion: nil)
            present(composer, animated: true, completion: {
                
//                UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
                
                //setStatusBarStyle:UIStatusBarStyleLightContent];
                
            })
        }
    }
    
//    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
//        switch result.rawValue {
//        
//            case MFMailComposeResultCancelled.rawValue: print("Mail cancelled")
//            case MFMailComposeResultSaved.rawValue: print("Mail saved")
//            case MFMailComposeResultSent.rawValue: print("Mail sent")
//            case MFMailComposeResultFailed.rawValue: print("Failed to send mail: \(error?.localizedDescription)")
//            default:
//                break
//        }
//        
//        // Dismiss the mail interface
//        dismissViewControllerAnimated(true, completion: nil)
//    }
    
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
    
    
    
    
    
    
//    @IBAction func visitWebSite(sender: AnyObject) {
//        
//        let tracker = GAI.sharedInstance().defaultTracker
//        let event = GAIDictionaryBuilder.createEventWithCategory(
//            "Website",
//            action: "visit_official_website",
//            label: nil,
//            value: nil).build()
//        tracker.send(event as [NSObject : AnyObject])
//        
//    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
