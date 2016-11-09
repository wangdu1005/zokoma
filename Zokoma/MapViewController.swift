//
//  MapViewController.swift
//  Zokoma
//
//  Created by jiro9611 on 12/2/15.
//  Copyright © 2015 jiro9611. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView:MKMapView!
    var restaurant:Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self;

        // Do any additional setup after loading the view.
        // Convert address to coordinate and annotate it on map
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location,
            completionHandler: { placemarks,
                error in
                if error != nil {
                    print(error as Any)
                    return
                }
                if placemarks != nil && placemarks!.count > 0 {
                    let placemark = placemarks![0] as CLPlacemark
                    // Add Annotation
                    let annotation = MKPointAnnotation()
                    annotation.title = self.restaurant.name
                    annotation.subtitle = self.restaurant.type
                    annotation.coordinate = placemark.location!.coordinate
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "MyPin"
        
            if annotation.isKind(of: MKUserLocation.self) {
                return nil
            }
            
            // reuse the annotation
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            }
            
            let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
            leftIconView.image = UIImage(data: restaurant.image as Data)
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
