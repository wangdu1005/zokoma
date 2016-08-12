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
        
        FIRAnalytics.logEventWithName("view_item", parameters: [
            "item_name": "aboutViewSuccess"
            ])

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendEmail (sender: AnyObject) {
        
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
            composer.navigationBar.tintColor = UIColor.whiteColor()
            
            //            presentViewController(composer, animated: true, completion: nil)
            presentViewController(composer, animated: true, completion: {
                
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
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
            
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
            
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
            
        case MFMailComposeResultFailed.rawValue:
            print("Failed to send mail: \(error?.localizedDescription)")
            
        default:
            break
        }
        
        // Dismiss the Mail interface
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    @IBAction func visitWebSite(sender: AnyObject) {
        print("visit website Button clicked")

        // Original way by blog post
        // After testing result, logEventWithName's name will show on the GA report in Event Action column
        // item_id (Event Action) must be fill in log event, otherwise GA can't recongize it.
        // And the content_type (Event Category) will show on the GA report in "Event Category" column.
        // Strang part is I set two log event in the same time when button click, but event "select_content" show the event category, event "view_time_action" didn't...
        // view_item_action's item_id become the event action column in GA report, but event select_content show "select_content" in event action column...
        //
        FIRAnalytics.logEventWithName("select_content", parameters: [
            "item_name": "button_click_new1",
            "content_type": "visitWebsite_category",
            "item_id": "visitWebAction1_1"
            ])
        
        FIRAnalytics.logEventWithName("view_item_action", parameters: [
            "item_name": "button_click_new2",
            "content_type": "visitWebsite_category",
            "item_id": "visitWebAction2_2",
//            "eventAction" : "visitWebSite",
//            "event" : "superVisitWebsite"
            ])
        
//        FIRAnalytics.logEventWithName("view_item", parameters: [
//            "item_name": "button_click_new",
//            "content_type": "visitWebsite_category",
//            "item_id": "visitWebAction3_3",
//            "eventAction" : "visitWebSite",
//            "event" : "superVisitWebsite"
//            ])
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
