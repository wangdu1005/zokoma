//
//  PageViewController.swift
//  Zokoma
//
//  Created by jiro9611 on 12/22/15.
//  Copyright © 2015 jiro9611. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var pageHeading = ["Personalize", "Locate", "Discover"]
    var pageImages = ["homei", "mapintro", "fiveleaves"]
    var pageSubHeading = ["Pin your favourite restaurants and create your own food guide", "Search and locate your favourite restaurants on Maps", "Find restaurants pinned by your friends and other foodies around the world!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the data source to itself
        dataSource = self
        
        // Create the first walkthrough screen
        if let startingViewController = self.viewControllerAtIndex(0) {
            setViewControllers([startingViewController], direction: .Forward, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    
        var index = (viewController as! PageContentViewController).index
        
        index += 1
        
        return self.viewControllerAtIndex(index)
    
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! PageContentViewController).index
        
        index -= 1
        
        return self.viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index:Int) -> PageContentViewController? {
    
        if index == NSNotFound || index < 0 || index >= self.pageHeading.count {
            return nil
        }
        
        // Build up new view controller and pass the proper data
        if let PageContentViewController = storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as? PageContentViewController {
                PageContentViewController.imageFile = pageImages[index]
                PageContentViewController.heading = pageHeading[index]
                PageContentViewController.subHeading = pageSubHeading[index]
                PageContentViewController.index = index
                return PageContentViewController
        }
        return nil
        
    }
    
    func forward(index: Int) {
        if let nextViewController = self.viewControllerAtIndex(index + 1) {
            setViewControllers([nextViewController], direction: .Forward, animated: true, completion: nil)
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
