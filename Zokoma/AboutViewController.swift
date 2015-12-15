//
//  AboutViewController.swift
//  Zokoma
//
//  Created by jiro9611 on 12/8/15.
//  Copyright © 2015 jiro9611. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendEmail (sender: AnyObject) {
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

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
