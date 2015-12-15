//
//  FeedDetailViewController.swift
//  Zokoma
//
//  Created by jiro9611 on 12/10/15.
//  Copyright © 2015 jiro9611. All rights reserved.
//

import UIKit
import CloudKit

class FeedDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var restaurantImageView:UIImageView!
    @IBOutlet var tableView:UITableView!

    var restaurant:CKRecord?
    
    // test array but it is empty.... no use
    var restaurants:[CKRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        // Fetch Image from Cloud in background
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant!.recordID])
        fetchRecordsImageOperation.desiredKeys = ["name", "image", "type", "location"]
        fetchRecordsImageOperation.queuePriority = .VeryHigh
        fetchRecordsImageOperation.perRecordCompletionBlock = {(record:CKRecord?, recordID:CKRecordID?, error:NSError?) -> Void in
            if (error != nil) {
                print("Failed to get restaurant image: \(error!.localizedDescription)")
            } else {
                if let restaurantRecord = record {
                    dispatch_async(dispatch_get_main_queue(), {
                        let imageAsset = restaurantRecord.objectForKey("image") as! CKAsset
                        self.restaurantImageView.image = UIImage(data: NSData(contentsOfURL: imageAsset.fileURL)!)
                        self.restaurant = restaurantRecord
                        self.tableView.reloadData()
                    })
                }
            }
        }
        publicDatabase.addOperation(fetchRecordsImageOperation)
        
        // Set table view background color
        self.tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        
        // Remove extra separator
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // Change separator color
        self.tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        
        // Set navigation bar title
        title = restaurant?.objectForKey("name") as? String
        
        
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
            cell.valueLabel.text = restaurant?.objectForKey("name") as? String
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = restaurant?.objectForKey("type") as? String
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = restaurant?.objectForKey("location") as? String
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
            destinationController.restaurant = restaurant
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
