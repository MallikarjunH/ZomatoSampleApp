//
//  RestaurantsDetailsVC.swift
//  ZomatoSampleApp
//
//  Created by mallikarjun on 22/01/20.
//  Copyright © 2020 Mallikarjun H. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class RestaurantsDetailsVC: UIViewController {

    var restaurantId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //https://developers.zomato.com/api/v2.1/restaurant?res_id=18595782
        
        self.getRestaurantDetailsAPICall()
    }
    
    func getRestaurantDetailsAPICall(){
        
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
                debugPrint(JSON)
                //parse your response here
                   
                DispatchQueue.main.async {
                    
                    //
                }
                
            case .failure(let error):
                debugPrint(error)
                SVProgressHUD.dismiss()
            }
        }
        
    }

   
}
