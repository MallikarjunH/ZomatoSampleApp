//
//  RestaurantsDetailsVC.swift
//  ZomatoSampleApp
//
//  Created by mallikarjun on 22/01/20.
//  Copyright © 2020 Mallikarjun H. All rights reserved.
//

import UIKit
import Alamofire
import IHProgressHUD

class RestaurantsDetailsVC: UIViewController,UITableViewDataSource, UITableViewDelegate {

    var restaurantId:String = ""
    var restaurantName:String = ""
    var restaurantImg:String = ""
    var restaurantAddress:String = ""
    var restaurantMenu:String = ""
    var restaurantTimings:String = ""
    var restaurantCost:String = ""
    var restaurantContact:String = ""
    
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        self.getRestaurantDetailsAPICall()
        self.title = restaurantName
        
        self.mainTableView!.tableFooterView = UIView()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
         return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantsDetailsCell1Id", for: indexPath) as! RestaurantsDetailsCell1
            
            if self.restaurantImg != ""{
                AppUtilitiesSwift.getData(from: self.restaurantImg as String) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() {
                        cell.restaurantImageView.image = UIImage(data: data)
                    }
                }
            }
            else{
                cell.restaurantImageView.image = UIImage(named: "imageNotFound.png")
            }
            
            
            return cell
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantsDetailsCell2Id", for: indexPath) as! RestaurantsDetailsCell2
            
            cell.addressLabel.text = restaurantAddress
            cell.cuisinesLabel.text = restaurantMenu
            cell.timingLabel.text = restaurantTimings
            cell.costLabel.text = restaurantCost
            cell.contactLabel.text = restaurantContact
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 180.0
        }
        else{
            return 220.0
        }
    }
    
    func getRestaurantDetailsAPICall(){
        
        IHProgressHUD.show()
        
        let url = "https://developers.zomato.com/api/v2.1/restaurant"
        let params: [String: Any] = [
            "res_id": restaurantId
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
                   
                    //Address
                    if let locationData:[String:Any] = dataDict["location"] as? [String:Any] {
                        
                        let addressValue:String = locationData["address"] as? String ??  "No Address Found"
                        self.restaurantAddress = addressValue
                    }
                    
                    //Cuisines
                    let cuisines:String = dataDict["cuisines"] as? String ??  "No cuisines Found"
                    self.restaurantMenu = cuisines
                    
                    //Timing
                    let time:String = dataDict["timings"] as? String ??  "Not Found"
                    self.restaurantTimings = time
                    
                    //Cost
                    let cost:Int = dataDict["average_cost_for_two"] as? Int ??  0
                    if cost == 0 {
                         self.restaurantTimings = "Average cost for two - Not Available"
                    }
                    else{
                         self.restaurantTimings = "Average cost for two - R.\(cost)"
                    }
                   
                    //contact //phone_numbers : "+91 8061915234" //restaurantContact
                    let contactNumber:String = dataDict["phone_numbers"] as? String ??  "Not Found"
                    self.restaurantContact = contactNumber
                    
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

   
}
