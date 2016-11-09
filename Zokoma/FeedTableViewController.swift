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
    
    var restaurantsParse:[String:String] = ["name":"hello world","image":"123.jpg"]

    var spinner:UIActivityIndicatorView = UIActivityIndicatorView()

    var imageCache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Configure the activity indicator and start animating
        spinner.activityIndicatorViewStyle = .gray
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        self.parent?.view.addSubview(spinner)
        spinner.startAnimating()
        
        // Pull To Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(FeedTableViewController.getRecordFromParse), for: UIControlEvents.valueChanged)
        
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // Parse 0 : excute the function
        return restaurantsParse.count
    }
    
    func getRecordFromParse() {
        
        // init empty restaurant array
        restaurantsParse = [:]
        
//        // get the image from Parse from background
//        // Create a new PFQuery
//        let query:PFQuery =  PFQuery(className: "Restaurant")
//        
//        // Call findObjectsInBackground
//        query.findObjectsInBackground { (objects:[PFObject]?, error:NSError?) -> Void in
//            
//            // Retrieve the data value of each PFObject
//            if error == nil {
//                for object in objects! {
//                    self.restaurantsParse.append(object)
//                }
//                
//                print("what is it in oject: \(self.restaurantsParse)")
//                
//                // stop spinner when download is done
//                if self.spinner.isAnimating {
//                    DispatchQueue.main.async(execute: {
//                        self.spinner.stopAnimating()
//                    })
//                }
//                
//                // hide the pull refresh
//                self.refreshControl?.endRefreshing()
//                
//                print("Successfuly retrieve the data from Parse!!")
//                DispatchQueue.main.async(execute: {
//                    self.tableView.reloadData()
//                })
//                
//                self.tableView.reloadData()
//                
//            } else {
//                print("Failed to get data from Parse -\(error)")
//            }
//            
//        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell!
        
        // when pull to refresh is activate, this will make sure the array is not out of index
        // Parse 1 : prevent empty value
        if restaurantsParse.isEmpty {
            print(" restaurantsParse is empty ")
            return cell!
        }
        
        // Parse 2 : Configure the cell...
        let restaurantParse : [String:AnyObject] = restaurantsParse[indexPath.row] as! [String:AnyObject]
        cell?.textLabel?.text = restaurantParse["name"] as? String
        
        // set default image
        cell?.imageView?.image = UIImage(named: "camera")
        
        cell?.imageView?.layer.cornerRadius = (cell?.imageView?.frame.size.width)! / 2
        cell?.imageView?.clipsToBounds = true
        
        // Parse 3 : if has the cache
        if let imageFileURL = imageCache.object(forKey: restaurantParse.objectId!) as? URL {
            
            print("Get image from cache url \(imageFileURL)")
            cell.imageView!.image = UIImage(data: try! Data(contentsOf: imageFileURL))
            
            cell?.imageView?.layer.cornerRadius = (cell?.imageView?.frame.size.width)! / 2
            cell?.imageView?.clipsToBounds = true
        
        } else {
            
            // Parse 4 : get the image from Parse from background
            let userImageFile = restaurantParse["image"] as? PFFile
            
            userImageFile!.getDataInBackground {
                (imageData: Data?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        DispatchQueue.main.async(execute: {
                            cell.imageView?.image = UIImage(data:imageData)
                            
                            cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.width)! / 2
                            cell.imageView?.clipsToBounds = true
                        })
                    }
                }
            }
        }
        return cell!
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "showDetail" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let destinationController = segue.destination as! FeedDetailViewController
                destinationController.restaurantParse = restaurantsParse[row]
            }
        }
    }
}
