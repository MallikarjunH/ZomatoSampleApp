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
import IHProgressHUD

class RestaurantsListVC: UIViewController,CLLocationManagerDelegate,UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var mainTableView: UITableView!
  
    var lattitudeValue:String = ""
    var longitudeValue:String = ""
    
    var restaurantNamesArray:[String] = []
    var restaurantIdArray:[String] = []
    var restaurantImgArray:[String] = []
    var restaurantThumbImgArray:[String] = []
    var restaurantWebSiteArray:[String] = []
    
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
        
        //tableViewcell
        self.mainTableView.register(UINib(nibName: "RestaurantsListCell", bundle: nil), forCellReuseIdentifier: "RestaurantsListCellId")
        
        self.mainTableView!.tableFooterView = UIView()
        self.mainTableView!.separatorStyle = .none
        
        self.getRestaurantsListAPICall()
        
    }
    
    //MARK: get actual locatioln
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        
        if let location = locations.first{
            
            //print(location.coordinate)
            
            print("Lattitude : \(location.coordinate.latitude)")
            print("Longitude : \(location.coordinate.longitude)")
            self.lattitudeValue = String(format: "%.2f", location.coordinate.latitude)
            self.longitudeValue = String(format: "%.2f", location.coordinate.longitude)
          
        }
    }

  
    //MARK: GET Restaurant List API Call
    func getRestaurantsListAPICall(){
        
        IHProgressHUD.show()
        
        
        let url = "https://developers.zomato.com/api/v2.1/geocode"
        let params: [String: Any] = [
            "lat": "12.97", //self.lattitudeValue,
            "lon": "‎77.64" //self.longitudeValue
        ]
        
        let headers: HTTPHeaders = [
            "user-key": "18efb2f1568a900815435ac7873d6ae7",
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let JSON):
               // debugPrint(JSON)
                
                if let dataDict = JSON as? [String:Any] {
                    
                    if let nearbyRestaurantsArray = dataDict["nearby_restaurants"] as? [[String:Any]] {
                        
                        self.restaurantNamesArray = []
                        self.restaurantIdArray = []
                        self.restaurantImgArray = []
                        self.restaurantThumbImgArray = []
                        self.restaurantWebSiteArray = []
                        
                        if nearbyRestaurantsArray.count > 0 {
                            
                            for dictData:Dictionary<String,Any> in nearbyRestaurantsArray{
                                
                                
                                if let restaurantDataDict = dictData["restaurant"] as? [String:Any] {
                                    
                                    let restaurantName:String = restaurantDataDict["name"] as? String ?? "No Name"
                                    let restaurantId:String = restaurantDataDict["id"] as? String ?? ""
                                    let restaurantFeatureImg:String = restaurantDataDict["featured_image"] as? String ?? ""
                                    let restaurantThumbImg:String = restaurantDataDict["thumb"] as? String ?? ""
                                    let restaurantWebSite:String = restaurantDataDict["url"] as? String ?? "https://www.google.com/"
                                    
                                    self.restaurantNamesArray.append(restaurantName)
                                    self.restaurantIdArray.append(restaurantId)
                                    self.restaurantImgArray.append(restaurantFeatureImg)
                                    self.restaurantThumbImgArray.append(restaurantThumbImg)
                                    self.restaurantWebSiteArray.append(restaurantWebSite)
                                }
                               
                            }
                            
                        }
                        else{
                            //no Restaurants present
                            AppUtilitiesSwift.showAlert(title: "Oops..", message: "No Restaurant Available in your area", vc: self)
                            IHProgressHUD.dismiss()
                        }
                        
                        
                    }
                }
                
                
                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                    IHProgressHUD.dismiss()
                }
                
            case .failure(let error):
                debugPrint(error)
               IHProgressHUD.dismiss()
            }
        }
    }
    
    
    //MARK: Tableview Datasource and Deleagte methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if self.restaurantNamesArray.count > 0
        {
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No data available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.restaurantNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantsListCellId", for: indexPath) as! RestaurantsListCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.restaurantNameLabel.text = self.restaurantNamesArray[indexPath.row]
        
        if self.restaurantImgArray[indexPath.item] != ""{
            AppUtilitiesSwift.getData(from: self.restaurantImgArray[indexPath.item] as String) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    cell.mainBGImage.image = UIImage(data: data)
                }
            }
        }
        else{
            cell.mainBGImage.image = UIImage(named: "imageNotFound.png")
        }
        
        if self.restaurantThumbImgArray[indexPath.item] != ""{
            AppUtilitiesSwift.getData(from: self.restaurantThumbImgArray[indexPath.item] as String) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    cell.thumbImage.image = UIImage(data: data)
                }
            }
        }
        else{
            
            cell.thumbImage.image = UIImage(named: "imageNotFound.png")
        }
        
        cell.websiteButton.layer.cornerRadius = 5.0
        cell.websiteButton.clipsToBounds = true
        
        cell.websiteButton.tag = indexPath.row
        cell.websiteButton.addTarget(self, action: #selector(webSiteButtonClickAction), for: .touchUpInside)
        
        return cell
        
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 210
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let restaurantDetailsVC = self.storyboard!.instantiateViewController(withIdentifier: "RestaurantsDetailsVCId") as? RestaurantsDetailsVC
        restaurantDetailsVC?.restaurantId = self.restaurantIdArray[indexPath.row]
        restaurantDetailsVC?.restaurantName = self.restaurantNamesArray[indexPath.row]
        restaurantDetailsVC?.restaurantImg = self.restaurantImgArray[indexPath.row]
        
        if (navigationController?.topViewController is RestaurantsDetailsVC) {
            return
        } else {
            navigationController?.pushViewController(restaurantDetailsVC!, animated: true)
        }
    }
    
    //MARK: Website Button clicked
    @objc func webSiteButtonClickAction(sender:UIButton){
        
        let myUrl = self.restaurantWebSiteArray[sender.tag]
        if let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
