//
//  AppDelegate.swift
//  Zokoma
//
//  Created by jiro9611 on 11/24/15.
//  Copyright © 2015 jiro9611. All rights reserved.
//

import UIKit
import CoreData
//import Parse
//import Bolts
import Firebase
import FirebaseAnalytics
import FirebaseStorage
import FirebaseDatabase
import FirebaseInstanceID
import GoogleTagManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Firebase Analytics =========================================================
        // Use Firebase library to configure APIs
        FIRApp.configure()
        
//        FIRAnalytics.logEventWithName(kFIREventSelectContent, parameters: [
//            kFIRParameterContentType:"cont",
//            kFIRParameterItemID:"1"
//            ])
        
//        FIRAnalytics.logEventWithName("share_image", parameters: [
//            "image_name": "test_jiro_img",
//            "full_text": "please_success"
//            ])
//
//        FIRAnalytics.logEventWithName("share_cool", parameters: [
//            "image_name": "wowowowowowowo"
//            ])
//        
//        FIRAnalytics.logEventWithName("share_beauty", parameters: [
//            "people_say": "wowowlaaaaaa",
//            "full_text": "iam the king in the world"
//            ])
        
//        FIRAnalytics.logEventWithName("TO_PROVE_IT_SUCCESS", parameters: [
//            "people_say": "wowowlaaaaaa",
//            "full_text": "iam the king in the world"
//            ])
        
//        FIRAnalytics.logEventWithName("share_data_layer", parameters: [
//            "share_data_cool": 310,
//            "share_data_hot": 520
//            ])
//        
//        FIRAnalytics.logEventWithName("share_data_error", parameters: [
//            "share_data_error_test": 786
//            ])
        
//        FIRAnalytics.setUserPropertyString("suicide_squad", forName: "favorite_movie")
        
        // Google Analytics =========================================================

        // Configure tracker from GoogleService-Info.plist.
//        var configureError:NSError?
//        GGLContext.sharedInstance().configureWithError(&configureError)
//        assert(configureError == nil, "Error configuring Google services: \(configureError)")
//        
//        // Optional: configure GAI options.
//        let gai = GAI.sharedInstance()
//        gai.trackUncaughtExceptions = true  // report uncaught exceptions
//        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release

        
        // Parse =====================================================================
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios/guide#local-datastore
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("GYLAJiDL5HiYULJo8qtgl4gLGzVlMgGZaqONxXEi",
            clientKey: "UMPZZEFitMUflBg1WOlPQw3PVuQBnUKq4FzArGqy")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpened(launchOptions: launchOptions)
        
        // Change the navifation background color
        UINavigationBar.appearance().barTintColor = UIColor(red: 216.0/255.0, green: 51.0/255.0, blue: 29.0/255.0, alpha: 1.0)
        
        // Change the navigation bar button color
        UINavigationBar.appearance().tintColor = UIColor.white
        
        // Change the text font style and color
        if let barFont = UIFont(name: "AvenirNextCondensed-DemiBold", size: 22.0) {
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName:barFont]
        }
        
        // Change the status bar appearence
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Change toolbar style
        // Font color
        // UIBarButtonItem.appearance().tintColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.5)
        
        // Background color
        // UIToolbar.appearance().barTintColor = UIColor(red: 237.0/255.0, green: 240.0/255.0, blue: 243.0/255.0, alpha: 0.5)
        
        // Edit tab bar appearence
        UITabBar.appearance().tintColor = UIColor(red: 216.0/255.0, green: 51.0/255.0, blue: 29.0/255.0, alpha: 1.0)
        
        UITabBar.appearance().barTintColor = UIColor.black
        
        UITabBar.appearance().selectionIndicatorImage = UIImage(named: "tabitem_selected")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.jiro9611.CoreDataDemo" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Zokoma", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("Zokoma.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext!.hasChanges {
            do {
                try managedObjectContext!.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }


}

