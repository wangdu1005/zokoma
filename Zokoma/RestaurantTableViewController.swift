//
//  RestaurantTableViewController.swift
//  Zokoma
//
//  Created by jiro9611 on 11/24/15.
//  Copyright © 2015 jiro9611. All rights reserved.
//

import UIKit
import CoreData
import Social

class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    var restaurants:[Restaurant] = []
    
    var fetchResultController:NSFetchedResultsController!
    
    var searchController:UISearchController!

    var searchResults:[Restaurant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Launch walkthrough tutorial screen
        let defaults = NSUserDefaults.standardUserDefaults()
        let hasViewedWalkthrough = defaults.boolForKey("hasViewedWalkthrough")
        if hasViewedWalkthrough == false {
            if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? PageViewController {
                self.presentViewController(pageViewController, animated: true, completion: nil)
            }
        }
        
//        else {
//            // Remove this code when development is over, otherwise the walkthrough will always appear!!!!! 20151222
//            if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? PageViewController {
//                self.presentViewController(pageViewController, animated: true, completion: nil)
//            }
//        }
        
        // Empty the back bar button title
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        // Self sizing cells
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        // Fetch the data from Coredata
        let fetchRequest = NSFetchRequest(entityName: "Restaurant")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
        
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
           
            do {
                try fetchResultController!.performFetch()
            } catch {
                print("An error occurred in fetchresultcontroller")
            }
            
            restaurants = fetchResultController.fetchedObjects as![Restaurant]
            
        }
        
        // Search bar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor.whiteColor()
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false

    }
    
    // Setting hises bar on swipe to be true in order to hide the bar during scroll
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Return the number of rows in the section
        if searchController.active {
            return searchResults.count
        } else {
            return self.restaurants.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CustomTableViewCell

        // Configure the cell...
        let restaurant = (searchController.active) ? searchResults[indexPath.row] : restaurants[indexPath.row]
        cell.nameLabel?.text = restaurant.name
        cell.typeLabel?.text = restaurant.type
        cell.locationLabel?.text = restaurant.location
        cell.thumbnailIamgeView?.image = UIImage(data: restaurant.image)
        cell.favorIconImageView.hidden = !restaurant.isVisited.boolValue

        // Circular image
        cell.thumbnailIamgeView?.layer.cornerRadius = cell.thumbnailIamgeView.frame.size.width / 2
        cell.thumbnailIamgeView?.clipsToBounds = true

        return cell
    }

    
    // Hide the Status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
        
            // Delete the data
            self.restaurants.removeAtIndex(indexPath.row)
            
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    //        Debug
    //        print("Total item:\(self.restaurantNames.count)")
    //        for name in restaurantNames {
    //            print(name)
    //        }
            
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction] {
        
        let restaurant = (searchController.active) ? searchResults[indexPath.row] : restaurants[indexPath.row]
        
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default ,title: "Share", handler: {(action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            let shareMenu = UIAlertController(title: nil, message: "Share using", preferredStyle: .ActionSheet)
            
//            let twitterAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default, handler: nil)
//            let facebookAction = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.Default, handler: nil)

            
            let twitterAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default, handler: {(action) -> Void in
            
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                    let tweetComposer = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    tweetComposer.setInitialText(restaurant.name)
                    tweetComposer.addImage(UIImage(data: restaurant.image)!)
                    self.presentViewController(tweetComposer, animated: true, completion: nil)
                } else {
                    let alertMessage = UIAlertController(title: " Twitter Unavailable", message: " You haven't registered your Twitter account. Please go to Setting > Twitter to create one.", preferredStyle: .Alert)
                    alertMessage.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(alertMessage, animated: true, completion: nil)
                }
                
            })
            
            
            
            let facebookAction = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.Default, handler: {(action) -> Void in
                
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                    let facebookComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    facebookComposer.setInitialText(restaurant.name)
                    facebookComposer.addImage(UIImage(data: restaurant.image)!)
                    facebookComposer.addURL(NSURL(string:"https://zokoma.wordpress.com"))
                    self.presentViewController(facebookComposer, animated: true, completion: nil)
                } else {
                    let alertMessage = UIAlertController(title: " Facebook Unavailable", message: " You haven't registered your Facebook account. Please go to Setting > Facebook to sign in or create one.", preferredStyle: .Alert)
                    alertMessage.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(alertMessage, animated: true, completion: nil)
                }
                
            })
            
            
//            let emailAction = UIAlertAction(title: "Email", style: UIAlertActionStyle.Default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
            
            shareMenu.addAction(twitterAction)
            shareMenu.addAction(facebookAction)
//            shareMenu.addAction(emailAction)
            shareMenu.addAction(cancelAction)
            
            self.presentViewController(shareMenu, animated: true, completion: nil)
            
            }
        )
        
        let deleteAction = UITableViewRowAction(
            style: UITableViewRowActionStyle.Default, title: "Delete", handler: {(action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                
                // Delete the row from the data source
                if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
                    let restaurantToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as! Restaurant
                    managedObjectContext.deleteObject(restaurantToDelete)
                
                    do {
                        try managedObjectContext.save()
                        print("Success delete the data")
                    } catch {
                        print("An error occurred when delete data")
                    }
                }
            }
        )
        
        shareAction.backgroundColor = UIColor(red: 255.0/255.0, green: 166.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 216.0/255.0, green: 51.0/255.0, blue: 29.0/255.0, alpha: 1.0)
        
        return [deleteAction, shareAction]
        
    }
    
    // When search bar were active then cell can not be edit
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            if searchController.active {
                return false
            } else {
                return true
            }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?) {
    
            switch type {
            
                case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
                case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                case .Update:
                tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                default:
                tableView.reloadData()
            }
            restaurants = controller.fetchedObjects as! [Restaurant]
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    
    // Search bar filter
    func filterContentForSearchText(searchText: String) {
        searchResults = restaurants.filter({(restaurant: Restaurant) -> Bool in
            let nameMatch = restaurant.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return nameMatch != nil
        })
    }
    
    // Search bar update
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        filterContentForSearchText(searchText!)
        tableView.reloadData()
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application - segue very important
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                // use destinationViewController can get the instance of the target view controller
                let destinationController = segue.destinationViewController as! DetailViewController
                destinationController.restaurant = (searchController.active) ? searchResults[indexPath.row] : restaurants[indexPath.row]
                
                destinationController.hidesBottomBarWhenPushed = true
            }
        }
    }
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
    
    }
}