//
//  ViewController.swift
//  MemorablePlaces
//
//  Created by Simranjit Kaur on 24/02/2016.
//  Copyright © 2016 Simranjit Kaur. All rights reserved.
//

import UIKit
import MapKit



class ViewController: UIViewController , CLLocationManagerDelegate {

    var manager : CLLocationManager!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        if activePlace == -1{
        
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            
        
        }else{
            let latitude = NSString(string :places[activePlace]["lat"]!).doubleValue
            let longitude = NSString(string :places[activePlace]["lon"]!).doubleValue
            
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            
            let latDelta:CLLocationDegrees = 0.01
            let longDelta:CLLocationDegrees = 0.01
            
            
            
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            
            let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
            
            self.map.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.title = places[activePlace]["name"]
            annotation.coordinate = coordinate
            self.map.addAnnotation(annotation)
        
        }
      
      
        
        let longUserPress = UILongPressGestureRecognizer(target: self, action: "action:")
        longUserPress.minimumPressDuration = 2.0
        
        map.addGestureRecognizer(longUserPress)
        
        
    }
    
    func action(gestureRecognizer:UIGestureRecognizer)
    {
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began
        {
            let touchPoint = gestureRecognizer.locationInView(self.map)
            
            let newCoordinate = self.map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error ) -> Void in
                
                var title = ""
                if (error == nil )
                {
                
                    if let p = placemarks?[0]
                    {
                        var subThoroughfare:String = ""
                        var thoroughfare :String = ""
                        
                        if p.subThoroughfare != nil{
                        
                            subThoroughfare = p.subThoroughfare!
                        }
                        if p.thoroughfare != nil
                        {
                            thoroughfare = p.thoroughfare!
                        }
                        
                       title = "\(subThoroughfare) \(thoroughfare)"
                    }
                    
                }
                
                if title == ""{
                    title = "Added \(NSDate())"
                }
                
               
                places.append(["name":title, "lat": "\(newCoordinate.latitude)" , "lon":"\(newCoordinate.longitude)"])
                print(places)
                
                let annotation = MKPointAnnotation()
                annotation.title = title
                annotation.coordinate = newCoordinate
                self.map.addAnnotation(annotation)
            })
            
            
        }
    
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        
      
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        
        self.map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

