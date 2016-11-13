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
//import Parse
//import Bolts

class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    var restaurants:[Restaurant] = []
    
    var fetchResultController:NSFetchedResultsController<NSFetchRequestResult>!
    
    var searchController:UISearchController!

    var searchResults:[Restaurant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Launch walkthrough tutorial screen
        let defaults = UserDefaults.standard
        let hasViewedWalkthrough = defaults.bool(forKey: "hasViewedWalkthrough")
        if hasViewedWalkthrough == false {
            if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "PageViewController") as? PageViewController {
                self.present(pageViewController, animated: true, completion: nil)
            }
        }
        
        else {
            // Remove this code when development is over, otherwise the walkthrough will always appear!!!!! 20151222
            if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "PageViewController") as? PageViewController {
                self.present(pageViewController, animated: true, completion: nil)
            }
        }
        
        // Empty the back bar button title
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Self sizing cells
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        // Fetch the data from Coredata
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurant")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext {
        
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
        searchController.searchBar.tintColor = UIColor.white
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false

    }
    
    // Setting hises bar on swipe to be true in order to hide the bar during scroll
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Return the number of rows in the section
        if searchController.isActive {
            return searchResults.count
        } else {
            return self.restaurants.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomTableViewCell

        // Configure the cell...
        let restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
        cell.nameLabel?.text = restaurant.name
        cell.typeLabel?.text = restaurant.type
        cell.locationLabel?.text = restaurant.location
        cell.thumbnailIamgeView?.image = UIImage(data: restaurant.image as Data)
        cell.favorIconImageView.isHidden = !restaurant.isVisited.boolValue

        // Circular image
        cell.thumbnailIamgeView?.layer.cornerRadius = cell.thumbnailIamgeView.frame.size.width / 2
        cell.thumbnailIamgeView?.clipsToBounds = true

        return cell
    }

    
    // Hide the Status bar
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        
            // Delete the data
            self.restaurants.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction] {
        
        let restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
        
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.default ,title: "Share", handler: {(action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in
            
            let shareMenu = UIAlertController(title: nil, message: "Share using", preferredStyle: .actionSheet)
            
            let twitterAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.default, handler: {(action) -> Void in
            
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                    let tweetComposer = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    tweetComposer?.setInitialText(restaurant.name)
                    tweetComposer?.add(UIImage(data: restaurant.image as Data)!)
                    self.present(tweetComposer!, animated: true, completion: nil)
                } else {
                    let alertMessage = UIAlertController(title: " Twitter Unavailable", message: " You haven't registered your Twitter account. Please go to Setting > Twitter to create one.", preferredStyle: .alert)
                    alertMessage.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alertMessage, animated: true, completion: nil)
                }
                
            })
            
            let facebookAction = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.default, handler: {(action) -> Void in
                
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                    let facebookComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    facebookComposer?.setInitialText(restaurant.name)
                    facebookComposer?.add(UIImage(data: restaurant.image as Data)!)
                    facebookComposer?.add(URL(string:"https://zokoma.wordpress.com"))
                    self.present(facebookComposer!, animated: true, completion: nil)
                } else {
                    let alertMessage = UIAlertController(title: " Facebook Unavailable", message: " You haven't registered your Facebook account. Please go to Setting > Facebook to sign in or create one.", preferredStyle: .alert)
                    alertMessage.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alertMessage, animated: true, completion: nil)
                }
                
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
            
            shareMenu.addAction(twitterAction)
            shareMenu.addAction(facebookAction)
            shareMenu.addAction(cancelAction)
            
            self.present(shareMenu, animated: true, completion: nil)
            
            }
        )
        
        let deleteAction = UITableViewRowAction(
            style: UITableViewRowActionStyle.default, title: "Delete", handler: {(action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in
                
                // Delete the row from the data source
                if let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext {
                    let restaurantToDelete = self.fetchResultController.object(at: indexPath) as! Restaurant
                    managedObjectContext.delete(restaurantToDelete)
                
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
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            if searchController.isActive {
                return false
            } else {
                return true
            }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
    
            switch type {
            
                case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
                case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
                case .update:
                tableView.reloadRows(at: [indexPath!], with: .fade)
                default:
                tableView.reloadData()
            }
            restaurants = controller.fetchedObjects as! [Restaurant]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    // Search bar filter
    func filterContentForSearchText(_ searchText: String) {
        searchResults = restaurants.filter({(restaurant: Restaurant) -> Bool in
            let nameMatch = restaurant.name.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return nameMatch != nil
        })
    }
    
    // Search bar update
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        filterContentForSearchText(searchText!)
        tableView.reloadData()
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application - segue very important
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                // use destinationViewController can get the instance of the target view controller
                let destinationController = segue.destination as! DetailViewController
                destinationController.restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
                
                destinationController.hidesBottomBarWhenPushed = true
            }
        }
    }
    
    @IBAction func unwindToHomeScreen(_ segue:UIStoryboardSegue) {
    
    }
}
