//
//  FeedMapViewController.swift
//  Zokoma
//
//  Created by jiro9611 on 12/11/15.
//  Copyright © 2015 jiro9611. All rights reserved.
//

import UIKit
import MapKit
import CloudKit

class FeedMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView:MKMapView!
    var restaurant:CKRecord?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self;
        
        // Do any additional setup after loading the view.
        // Convert address to coordinate and annotate it on map
        let geoCoder = CLGeocoder()
        let location = restaurant?.objectForKey("location") as? String
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
                    annotation.title = self.restaurant?.objectForKey("name") as? String
                    annotation.subtitle = self.restaurant?.objectForKey("type") as? String
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
        
        let imageAsset = restaurant?.objectForKey("image") as! CKAsset
        leftIconView.image = UIImage(data: NSData(contentsOfURL: imageAsset.fileURL)!)
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
