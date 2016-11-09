//
//  DetailViewController.swift
//  Zokoma
//
//  Created by jiro9611 on 11/26/15.
//  Copyright © 2015 jiro9611. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var restaurant:Restaurant!
    
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var tableView:UITableView!
    @IBOutlet var toolBar:UIToolbar!
    
    // recieve the segue image name from RestaurantTableViewController
    var restaurantImage:String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Show the image from RestaurantTableViewController
        self.restaurantImageView.image = UIImage(data: restaurant.image as Data)
        
        // Adjust the apperence of detail view controller
        self.tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        
        // Show the restaurant name on nav bar title
        title = self.restaurant.name
        
        // Change this current toolbar style
        // Font color
        self.toolBar.tintColor = UIColor(red: 216.0/255.0, green: 51.0/255.0, blue: 29.0/255.0, alpha: 1.0)
        
        // Background color
        self.toolBar.barTintColor = UIColor.black


        
        // Self sizing cells
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension;

    }

    // Setting hises bar on swipe to be false in order to remain the bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailTableViewCell
        
        cell.backgroundColor = UIColor.clear
        
        //Configure the cell
        cell.mapButton.isHidden = true
        
        switch indexPath.row {
        
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = restaurant.name
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = restaurant.type
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = restaurant.location
            cell.mapButton.isHidden = false
        case 3:
            cell.fieldLabel.text = "Been here"
            cell.valueLabel.text = (restaurant.isVisited.boolValue) ? "Yes, I've been here before" : "No"
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        
        }
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ segue:UIStoryboardSegue){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let destinationController = segue.destination as! MapViewController
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
