//
//  FeedDetailViewController.swift
//  Zokoma
//
//  Created by jiro9611 on 12/10/15.
//  Copyright © 2015 jiro9611. All rights reserved.
//

import UIKit
import Parse
import Bolts

class FeedDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var restaurantImageView:UIImageView!
    @IBOutlet var tableView:UITableView!

    var restaurantParse:PFObject?
    
    var restaurantsParse:[PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        // Fetch Image from Parse in backgorund
        // Create a new PFQuery
        let query:PFQuery =  PFQuery(className: "Restaurant")
        query.whereKey("objectId", equalTo:(restaurantParse?.objectId)!)
        
        print("test restaurantParse?.objectId: \(restaurantParse?.objectId) Ya!!! ")
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects![0].objectForKey("name")) scores.")
                
                if let restaurantObject = objects?[0]  {

                    print(" print the object : \(restaurantObject)")
                    
                    // Get the image from restaurantObject
                    let userImageFile = restaurantObject["image"] as? PFFile
                    
                    userImageFile!.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        if error == nil {
                            if let imageData = imageData {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.restaurantImageView.image = UIImage(data:imageData)
                                })
                            }
                        }
                    }
                    
                    self.restaurantParse = restaurantObject
                    self.tableView.reloadData()
                }
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        // Set table view background color
        self.tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        
        // Remove extra separator
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // Change separator color
        self.tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        
        // Set navigation bar title
        title = restaurantParse?.objectForKey("name") as? String
        
        
        tableView.estimatedRowHeight = 36.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! DetailTableViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        // Configure the cell...
        cell.mapButton.hidden = true
        
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = restaurantParse?.objectForKey("name") as? String
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = restaurantParse?.objectForKey("type") as? String
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = restaurantParse?.objectForKey("location") as? String
            cell.mapButton.hidden = false
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
            
        }
        
        return cell
    }
    
    @IBAction func close(segue:UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMap" {
            // Directly send the selected restaurant to the FeedMapView by Segue
            let destinationController = segue.destinationViewController as! FeedMapViewController
            destinationController.restaurantParse = restaurantParse
        }
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
