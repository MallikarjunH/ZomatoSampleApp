//
//  RestaurantsListVC.swift
//  ZomatoSampleApp
//
//  Created by mallikarjun on 22/01/20.
//  Copyright © 2020 Mallikarjun H. All rights reserved.
//

import UIKit
import CoreLocation

class RestaurantsListVC: UIViewController,CLLocationManagerDelegate {

    //Create Location Manger constant
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // FOr use when app is open and in the background mode
         locationManager.requestAlwaysAuthorization()
         
         // For use when the app is open
        // locationManager.requestWhenInUseAuthorization()
         
         if CLLocationManager.locationServicesEnabled() {
             
             locationManager.delegate = self
             locationManager.desiredAccuracy = kCLLocationAccuracyBest
             locationManager.startUpdatingLocation()
         }
        
        self.getRestaurantsListAPICall()
    }
    
    //get actual locatioln
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        
        if let location = locations.first{
            
            //print(location.coordinate)
            
            print("Lattitude : \(location.coordinate.latitude)")
            print("Longitude : \(location.coordinate.longitude)")
          
        }
    }

  
    func getRestaurantsListAPICall(){
        
    }

}
