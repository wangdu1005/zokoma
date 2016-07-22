//
//  FeedMapViewController.swift
//  Zokoma
//
//  Created by jiro9611 on 12/11/15.
//  Copyright © 2015 jiro9611. All rights reserved.
//

import UIKit
import MapKit
//import Parse
//import Bolts

class FeedMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView:MKMapView!
    var restaurantParse:PFObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self;
        
        // Do any additional setup after loading the view.
        // Convert address to coordinate and annotate it on map
        let geoCoder = CLGeocoder()
        let location = restaurantParse?.objectForKey("location") as? String
        geoCoder.geocodeAddressString(location!,
            completionHandler: { placemarks,
                error in
                if error != nil {
                    print(error)
                    return
                }
                if placemarks != nil && placemarks!.count > 0 {
                    let placemark = placemarks![0] as CLPlacemark
                    // Add Annotation
                    let annotation = MKPointAnnotation()
                    annotation.title = self.restaurantParse?.objectForKey("name") as? String
                    annotation.subtitle = self.restaurantParse?.objectForKey("type") as? String
                    annotation.coordinate = placemark.location!.coordinate
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
        })
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        // reuse the annotation
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRectMake(0, 0, 53, 53))
        
        let imageAsset = restaurantParse?.objectForKey("image") as! PFFile
        
        imageAsset.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    dispatch_async(dispatch_get_main_queue(), {
                        leftIconView.image = UIImage(data:imageData)
                    })
                }
            }
        }

        annotationView?.leftCalloutAccessoryView = leftIconView
        
        return annotationView
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
