//
//  AppUtilitiesSwift.swift
//  ZomatoSampleApp
//
//  Created by mallikarjun on 22/01/20.
//  Copyright © 2020 Mallikarjun H. All rights reserved.
//

import Foundation
import UIKit

class AppUtilitiesSwift: NSObject {
    
    
    
    static let sharedUtilityInstance: AppUtilitiesSwift? = {
        var instance = AppUtilitiesSwift()
        return instance
    }()
    
    class func sharedUtility() -> AppUtilitiesSwift? {
        return sharedUtilityInstance
    }
    
    
    class func getData(from url: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        
        let imageURL:String = url // valid
        
        let imgURL = URL(string: imageURL)
        
        URLSession.shared.dataTask(with: imgURL!, completionHandler: completion).resume()
    }
    
    class  func showAlert(title:String, message:String, vc: UIViewController) {
        
        let alertView1 = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView1.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        vc.present(alertView1,animated: true,completion: nil)
    }
    
}

