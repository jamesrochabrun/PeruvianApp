//
//  Backups.swift
//  Pods
//
//  Created by James Rochabrun on 4/5/17.
//
//

import Foundation

//
//func getTokn() {
//    
//    let urlStr = "https://api.yelp.com/oauth2/token"
//    let url = URL(string: urlStr)
//    let request: NSMutableURLRequest = NSMutableURLRequest(url: url!)
//    request.httpMethod = "POST"
//    
//    let client_id = "client_id=2f5-nq6WiXCN89EdEo6j9Q"
//    let client_secret = "client_secret=uzW9fTnBTuOEvzb3bPx1aHMxR5ADq76RK7WMeyyznwgAETUTqq5M9l4Uw2q2TSyL"
//    let grant_type = "grant_type=client_credentials"
//    
//    let parameters = grant_type + "&" + client_id + "&&" + client_secret
//    
//    request.httpBody = parameters.data(using: String.Encoding.ascii, allowLossyConversion: false)
//    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//    
//    let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
//        
//        do {
//            
//            if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] {
//                
//                //                    let token = json["access_token"] as! String
//            }
//            
//        } catch {
//            
//        }
//    }
//    task.resume()
//}
