//
//  FeedTableViewController.swift
//  Zokoma
//
//  Created by jiro9611 on 12/10/15.
//  Copyright © 2015 jiro9611. All rights reserved.
//

import UIKit
import Parse
import Bolts

class FeedTableViewController: UITableViewController {
    
    var restaurantsParse:[PFObject] = []

    var spinner:UIActivityIndicatorView = UIActivityIndicatorView()

    var imageCache:NSCache = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Configure the activity indicator and start animating
        spinner.activityIndicatorViewStyle = .Gray
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        self.parentViewController?.view.addSubview(spinner)
        spinner.startAnimating()
        
        // Pull To Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.whiteColor()
        refreshControl?.tintColor = UIColor.grayColor()
        refreshControl?.addTarget(self, action: #selector(FeedTableViewController.getRecordFromParse), forControlEvents: UIControlEvents.ValueChanged)
        
        self.getRecordFromParse()
        
        //Google Analytics Screen Track
//        let tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: "FeedTableView")
//        
//        let builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // Parse 0 : excute the function
        return restaurantsParse.count
    }
    
    func getRecordFromParse() {
        
        // init empty restaurant array
        restaurantsParse = []
        
        // get the image from Parse from background
        // Create a new PFQuery
        let query:PFQuery =  PFQuery(className: "Restaurant")
        
        // Call findObjectsInBackground
        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
            
            // Retrieve the data value of each PFObject
            if error == nil {
                for object in objects! {
                    self.restaurantsParse.append(object)
                }
                
                print("what is it in oject: \(self.restaurantsParse)")
                
                // stop spinner when download is done
                if self.spinner.isAnimating() {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.stopAnimating()
                    })
                }
                
                // hide the pull refresh
                self.refreshControl?.endRefreshing()
                
                print("Successfuly retrieve the data from Parse!!")
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
                
                self.tableView.reloadData()
                
            } else {
                print("Failed to get data from Parse -\(error)")
            }
            
        }
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell!
        
        // when pull to refresh is activate, this will make sure the array is not out of index
        // Parse 1 : prevent empty value
        if restaurantsParse.isEmpty {
            print(" restaurantsParse is empty ")
            return cell
        }
        
        // Parse 2 : Configure the cell...
        let restaurantParse = restaurantsParse[indexPath.row]
        cell.textLabel?.text = restaurantParse["name"] as? String
        
        // set default image
        cell.imageView?.image = UIImage(named: "camera")
        
        cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.width)! / 2
        cell.imageView?.clipsToBounds = true
        
        // Parse 3 : if has the cache
        if let imageFileURL = imageCache.objectForKey(restaurantParse.objectId!) as? NSURL {
            
            print("Get image from cache url \(imageFileURL)")
            cell.imageView!.image = UIImage(data: NSData(contentsOfURL: imageFileURL)!)
            
            cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.width)! / 2
            cell.imageView?.clipsToBounds = true
        
        } else {
            
            // Parse 4 : get the image from Parse from background
            let userImageFile = restaurantParse["image"] as? PFFile
            
            userImageFile!.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        dispatch_async(dispatch_get_main_queue(), {
                            cell.imageView?.image = UIImage(data:imageData)
                            
                            cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.width)! / 2
                            cell.imageView?.clipsToBounds = true
                        })
                    }
                }
            }
        }
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "showDetail" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let destinationController = segue.destinationViewController as! FeedDetailViewController
                destinationController.restaurantParse = restaurantsParse[row]
            }
        }
    }
}
