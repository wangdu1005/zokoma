//
//  AddTableViewController.swift
//  Zokoma
//
//  Created by jiro9611 on 12/3/15.
//  Copyright © 2015 jiro9611. All rights reserved.
//

import UIKit
import CoreData
import CloudKit
import Parse
import Bolts

class AddTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var restaurant:Restaurant!
    
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var nameTextField:UITextField!
    @IBOutlet weak var typeTextField:UITextField!
    @IBOutlet weak var locationTextField:UITextField!
    @IBOutlet weak var yesButton:UIButton!
    @IBOutlet weak var noButton:UIButton!
    
    var isVisited = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.delegate = self
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func save() {
    
        // Form validation
        var errorField = ""
        
        if nameTextField.text == "" {
            errorField = "name"
        } else if locationTextField.text == "" {
            errorField = "location"
        } else if typeTextField.text == "" {
            errorField = "type"
        }
        
        if errorField != "" {
            
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed as you forget to fill in the restaurant " + errorField + ". All fields are mandatory.", preferredStyle: .Alert)
            let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(doneAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        // If all fields are correctly filled in, extract the field value
        // Create Restaurant Object and save to Local Core Data store
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            
            restaurant = NSEntityDescription.insertNewObjectForEntityForName("Restaurant",
                inManagedObjectContext: managedObjectContext) as! Restaurant
            restaurant.name = nameTextField.text
            restaurant.type = typeTextField.text
            restaurant.location = locationTextField.text
            restaurant.image = UIImagePNGRepresentation(imageView.image!)
            restaurant.isVisited = isVisited
            
            // The newest way to handle error situation
            do {
                try managedObjectContext.save()
                print("Jiro test The name is: \(restaurant.name)")
                print("Jiro test The tyoe is: \(restaurant.type)")
                print("Jiro test The location is: \(restaurant.location)")
                print("Jiro test The isVisited is: " + (isVisited ? "Yes" : "No"))
            } catch let e {
                print("Could not cache the response \(e)")
            }
            
        }
        
        // Save record to the iCloud and share the restaurant with others (public DB)
        saveRecordToCloud(restaurant)
        
        //Excute the unwind segue and go back to the home screen
        performSegueWithIdentifier("unwindToHomeScreen", sender: self)
        
    }
    
    @IBAction func updateIsVisited(sender: AnyObject) {
        // yes button clicked
        let buttonClicked = sender as! UIButton
        if buttonClicked == yesButton {
            isVisited = true
            yesButton.backgroundColor = UIColor(red: 216.0/255.0, green: 51.0/255.0, blue: 29.0/255.0, alpha: 1.0)
            noButton.backgroundColor = UIColor.grayColor()
        } else if buttonClicked == noButton {
            isVisited = false
            yesButton.backgroundColor = UIColor.grayColor()
            noButton.backgroundColor = UIColor(red: 216.0/255.0, green: 51.0/255.0, blue: 29.0/255.0, alpha: 1.0)
        }
        
    }
    
    func saveRecordToCloud(restaurant:Restaurant!) -> Void {
        
        //prepare the record to save
        let record = CKRecord(recordType: "Restaurant")
        record.setValue(restaurant.name, forKey: "name")
        record.setValue(restaurant.type, forKey: "type")
        record.setValue(restaurant.location, forKey: "location")
        
        //Resize the image
        let originalImage = UIImage(data: restaurant.image)
//        let NSDataImage = NSData(data: restaurant.image)
        let scalingFactor = (originalImage!.size.width > 1024) ? 1024 / originalImage!.size.width : 1.0
        let scaledImage = UIImage(data: restaurant.image, scale: scalingFactor)
        // Write the image to local file for temporary use
        let imageFilePath = NSTemporaryDirectory() + restaurant.name
        UIImageJPEGRepresentation(scaledImage!, 0.8)!.writeToFile(imageFilePath, atomically: true)
        
        // Create image asset for upload
        let imageFileURL = NSURL(fileURLWithPath: imageFilePath)
        let imageAsset = CKAsset(fileURL: imageFileURL)
        record.setValue(imageAsset, forKey: "image")
        
        // Get the public icloud database
        //cloudContainer
        _ = CKContainer.defaultContainer()
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        
        // Save the record to iCloud
        publicDatabase.saveRecord(record, completionHandler: { (record:CKRecord?, error:NSError?) -> Void  in
            
            // Remove temp file
            // New error handling method in Swift 2.0
            do {
                try NSFileManager.defaultManager().removeItemAtPath(imageFilePath)
            } catch let error as NSError{
                print("Failed to save record to the iCloud: \(error.description)")
            }
            
        })
        
        
        // ==Parse==20151224==
        // prepare the record to save to Parse cloud
        // Create a PFObject
        let newRestaurantObj:PFObject = PFObject(className: "Restaurant")
        
        
        // Set the data key of the restaurant
//        let testgetImageType = getImageType(NSDataImage)
//        print("return the format of image \(testgetImageType)")
    
        let imageGet = UIImage(data: restaurant.image)
        let imageData = UIImagePNGRepresentation(imageGet!)
        let imageFile = PFFile(name:"image.png", data:imageData!)
        
        newRestaurantObj["image"] = imageFile
        newRestaurantObj["name"] = restaurant.name
        newRestaurantObj["type"] = restaurant.type
        newRestaurantObj["location"] = restaurant.location
        
        // Save the PFObject
        newRestaurantObj.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            
            if(success == true) {
                // Message has been saved!!!
                // Retrieve the latest message and reload the table
                //                self.retrieveMessages()
                NSLog("Restaurant info saved to Parse successfully.")
            } else {
                // Something went wrong!!!
                NSLog(error!.description)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                // Do any additional action here after save data to Parse
            }
        }
        
    }
    
// MARK: - To do : getImageType
//    func getImageType(imgData : NSData) -> String {
//        
//        var array = [UInt8](count: 1, repeatedValue: 0)
//        
//        imgData.getBytes(&array, length: 1)
//        
//        print(array)
//        
//        let ext : String
//        
//        switch (array[0]) {
//        case 0xFF:
//            
//            ext = "jpg\(array[0])"
//            
//        case 0x89:
//            
//            ext = "png\(array[0])"
//        case 0x47:
//            
//            ext = "gif\(array[0])"
//        case 0x49, 0x4D :
//            
//            ext = "tiff\(array[0])"
//        default:
//            ext = "" //unknown
//        }
//        
//        return ext
//
//    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
