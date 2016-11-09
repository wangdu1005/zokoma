//
//  ShareViewController.swift
//  Zokoma
//
//  Created by jiro9611 on 12/1/15.
//  Copyright © 2015 jiro9611. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView:UIImageView!

    @IBOutlet weak var facebookButton:UIButton!
    @IBOutlet weak var twitterButton:UIButton!
    @IBOutlet weak var messageButton:UIButton!
    @IBOutlet weak var emailButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // apply backgrund image blur effect
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        // Move the button off the screen (bottom)
        let translateDown = CGAffineTransform(translationX: 0, y: 1000)
        facebookButton.transform = translateDown
        messageButton.transform = translateDown
        
        // Move the buttons off the screen (top)
        let translateUp = CGAffineTransform(translationX: 0, y: -1000)
        twitterButton.transform = translateUp
        emailButton.transform = translateUp
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let translate = CGAffineTransform(translationX: 0, y: 0)
        facebookButton.isHidden = false
        twitterButton.isHidden = false
        messageButton.isHidden = false
        emailButton.isHidden = false
        
        UIView.animate(withDuration: 0.8, delay: 0.0,usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
        
            self.facebookButton.transform = translate
            self.emailButton.transform = translate
            
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8, delay: 0.5,usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            
            self.twitterButton.transform = translate
            self.messageButton.transform = translate
            
            }, completion: nil)
    }

}
