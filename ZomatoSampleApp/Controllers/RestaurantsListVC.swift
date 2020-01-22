//
//  RestaurantsListVC.swift
//  ZomatoSampleApp
//
//  Created by mallikarjun on 22/01/20.
//  Copyright © 2020 Mallikarjun H. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class RestaurantsListVC: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var tempLabel: UILabel!
    
    var cityName:String = ""
    
    var lattitudeValue:String = ""
    var longitudeValue:String = ""
    
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
            self.lattitudeValue = String(format: "%.2f", location.coordinate.latitude)
            self.longitudeValue = String(format: "%.2f", location.coordinate.longitude)
          
        }
    }

  
    func getRestaurantsListAPICall(){
        
        let url = "https://developers.zomato.com/api/v2.1/geocode"
        let params: [String: Any] = [
            "lat": "12.97", //self.lattitudeValue,
            "lon": "‎77.64"//self.longitudeValue
        ]
        
        
        let headers: HTTPHeaders = [
            "user-key": "18efb2f1568a900815435ac7873d6ae7",
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let JSON):
                debugPrint(JSON)
                //parse your response here
                
                if let dataDict = JSON as? [String:Any] {
                    
                    if let nearbyRestaurantsArray = dataDict["nearby_restaurants"] as? [[String:Any]] {
                        
                        if nearbyRestaurantsArray.count > 0 {
                            
                            
                        }
                        else{
                            //no Restaurants present
                        }
                       // let cityName:String = (locationDict["city_name"] as? String)!
                    
                    }
                }
                
                DispatchQueue.main.async {
                    
                    self.tempLabel.text = self.cityName
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
        
    }

}
