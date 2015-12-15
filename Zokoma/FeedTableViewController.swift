//
//  FeedTableViewController.swift
//  Zokoma
//
//  Created by jiro9611 on 12/10/15.
//  Copyright © 2015 jiro9611. All rights reserved.
//

import UIKit
import CloudKit

class FeedTableViewController: UITableViewController {
    
    var restaurants:[CKRecord] = []

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
        refreshControl?.addTarget(self, action: "getRecordsFromCloud", forControlEvents: UIControlEvents.ValueChanged)

        
        self.getRecordsFromCloud()
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
        return restaurants.count
    }

    func getRecordsFromCloud() {
        
        // init empty restaurant array
        restaurants = []
        
        // Fetch data using Convenience API
        //cloudContainer
        _ = CKContainer.defaultContainer()
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        
        // Prepare for search
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // use query to set up the search
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name"]
        queryOperation.queuePriority = .VeryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordFetchedBlock = { (record:CKRecord!) -> Void in
            if let restaurantRecord = record {
                self.restaurants.append(restaurantRecord)
            }
        }
        
        queryOperation.queryCompletionBlock = {(cursor:CKQueryCursor?, error:NSError?) -> Void in
            
            // stop spinner when download is done
            if self.spinner.isAnimating() {
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.stopAnimating()
                })
            }
            
            // hide the pull refresh
            self.refreshControl?.endRefreshing()
            
            if (error != nil) {
                print("Failed to get data from iCloud -\(error!.localizedDescription)")
            } else {
                print("Successfuly retrieve the data from iCloud")
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        
        }
        
        // Excute the query
        publicDatabase.addOperation(queryOperation)
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell!
        
        // when pull to refresh is activate, this will make sure the array is not out of index
        if restaurants.isEmpty {
            return cell
        }

        // Configure the cell...
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = restaurant.objectForKey("name") as? String
        
        // set default image
        cell.imageView?.image = UIImage(named: "camera")
        
        cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.width)! / 2
        cell.imageView?.clipsToBounds = true
        
        // check if have cache of this image then use cache
        if let imageFileURL = imageCache.objectForKey(restaurant.recordID) as? NSURL {
            
            print("Get image from cache")
            cell.imageView!.image = UIImage(data: NSData(contentsOfURL: imageFileURL)!)
            
            cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.width)! / 2
            cell.imageView?.clipsToBounds = true
        
        } else {
        
            // get the image from icloud from background
            let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
            
            let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
            
            fetchRecordsImageOperation.desiredKeys = ["image"]
            fetchRecordsImageOperation.queuePriority = .VeryHigh
            fetchRecordsImageOperation.perRecordCompletionBlock = {(record:CKRecord?, recordID:CKRecordID?, error:NSError?) -> Void in
                if (error != nil) {
                    print("Failed to get restaurant image: \(error?.localizedDescription)")
                } else {
                    if let restaurantRecord = record {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            let imageAsset = restaurantRecord.objectForKey("image") as! CKAsset
                            
                            cell.imageView?.image = UIImage(data: NSData(contentsOfURL: imageAsset.fileURL)!)
                            
                            cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.width)! / 2
                            cell.imageView?.clipsToBounds = true
                        })
                    }
                }
            }
            publicDatabase.addOperation(fetchRecordsImageOperation)
        }

        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "showDetail" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let destinationController = segue.destinationViewController as! FeedDetailViewController
                destinationController.restaurant = restaurants[row]
            }
        }
    }
}
