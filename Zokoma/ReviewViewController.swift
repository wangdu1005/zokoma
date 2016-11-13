//
//  ReviewViewController.swift
//  Zokoma
//
//  Created by jiro9611 on 11/30/15.
//  Copyright © 2015 jiro9611. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView:UIImageView!
    @IBOutlet weak var dialogView:UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Blur the background image
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        // Combining scale and translate transforms
        let scale = CGAffineTransform(scaleX: 0.0, y: 0.0)
        let translate = CGAffineTransform(translationX: 0, y: 500)
        dialogView.transform = scale.concatenating(translate)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // http://stackoverflow.com/questions/32638488/nil-is-not-compatible-with-expected-argument-type-uiviewanimationoptions
    override func viewDidAppear(_ animated: Bool) {

        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [], animations: {
            
            let scale = CGAffineTransform(scaleX: 1, y: 1)
            let translate = CGAffineTransform(translationX: 0, y: 0)
            self.dialogView.transform = scale.concatenating(translate)
            
            }, completion: nil)
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
