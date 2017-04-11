//
//  YelpAPI.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/5/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import TRON
import SwiftyJSON


struct YelpService: Gettable {
    
    //MARK: constants
    static let clientID: String = "2f5-nq6WiXCN89EdEo6j9Q"
    static let clientSecret: String = "uzW9fTnBTuOEvzb3bPx1aHMxR5ADq76RK7WMeyyznwgAETUTqq5M9l4Uw2q2TSyL"
    static let grantType: String = "client_credentials"
    static let keyClientID: String = "client_id"
    static let keyClientSecret: String = "client_secret"
    static let keyGrantType: String = "grant_type"
    let accessToken = "mS62uF4nkSmm0MDETma145S_DH3eNk12GpuJa9IpxBdBfHJbDjNfFbIp_90kwNhmQzKe70-7tVUMAt_el2gqoGza5xu4N20EhgMxPTO_GSHn9qNSUkC8KEXZBQPlWHYx"
    
    //MARK: properties
    //MARK: singleton
    static let sharedInstance = YelpService()
    private init() {}
    //MARK: tron object
    let tron = TRON(baseURL: "https://api.yelp.com/")
    
    //MARK: TypeAliases
    typealias SearchBusinessCompletionHandler = (Result<BusinessDataSource>) -> ()
    typealias TokenCompletionhandler = (Result<Token>) -> ()
    typealias SearchBusinessFromCategoriesCompletionHandler = (Result<BusinessDataSource>) -> ()
    typealias SeachBusinessFromIDCompletion = (Result<Business>) -> ()
    
    //MARK: GET BUSINESSESES FROM TERM
    func getBusinesses(search term: String, completion: @escaping SearchBusinessCompletionHandler) {
        
        let request: APIRequest<BusinessDataSource, JSONError> = tron.request("v3/businesses/search")
        request.headers = ["Authorization": "Bearer \(accessToken)"]
        
        let parameters =  ["term" : term,
                           "latitude" : "37.785771",
                           "longitude" : "-122.406165",
                           "categories" : "vegetarian,thai"]
        
        request.parameters = parameters
        
        request.perform(withSuccess: { (businessDataSource) in
            DispatchQueue.main.async {
                completion(.Success(businessDataSource))
            }
        }, failure: { (error) in
            completion(.Error(error))
        })
    }
    
    //MARK: GET BUSINESSES FROM SELECTION MAIN METHOD
    func getBusinessesFrom(selection: Selection, completion: @escaping SearchBusinessFromCategoriesCompletionHandler) {
        
        let request: APIRequest<BusinessDataSource, JSONError> = tron.request("v3/businesses/search")
        request.headers = ["Authorization": "Bearer \(accessToken)"]
        
        let categories = selection.categoryItems.count <= 0 ? selection.categoryParent : selection.categoryItems.joined(separator: ",")
        
        let parameters =  ["latitude" : "37.785771",
                           "longitude" : "-122.406165",
                           "categories" : categories]
        
        request.parameters = parameters
        
        request.perform(withSuccess: { (businessDataSource) in
            DispatchQueue.main.async {
                completion(.Success(businessDataSource))
            }
        }, failure: { (error) in
            completion(.Error(error))
        })
    }
    
    //MARK: GET BUSINESS FROM ID
    func getBusinessFrom(id: String, completion: @escaping SeachBusinessFromIDCompletion) {
        
        let request: APIRequest<Business, JSONError> = tron.request("v3/businesses/\(id)")
        request.headers = ["Authorization": "Bearer \(accessToken)"]
        request.perform(withSuccess: { (business) in
            DispatchQueue.main.async {
                completion(.Success(business))
            }
        }, failure: { (error) in
            completion(.Error(error))
        })
    }
    
    //MARK: GET TOKEN
    func getToken(completion: @escaping TokenCompletionhandler) {
        
        let request: APIRequest<Token, JSONError> = tron.request("oauth2/token")
        request.method = .post
        request.parameters = [YelpService.keyClientID: YelpService.clientID,
                              YelpService.keyClientSecret: YelpService.clientSecret,
                              YelpService.keyGrantType: YelpService.grantType]
        request.headers = ["Content-Type" : "application/x-www-form-urlencoded"]
        
        request.perform(withSuccess: { (token) in
            completion(.Success(token))
        }, failure: { (err) in
            completion(.Error(err))
        })
    }
}

//MARK: TOKEN object
struct Token: JSONDecodable {
    
    let access_token: String
    let token_type: String
    let expires_in: NSNumber
    
    private struct Key {
        static let keyAccessToken = "access_token"
        static let keyTokenType = "token_type"
        static let keyExpiresIn = "expires_in"
    }
    
    init(json: JSON) throws {
        access_token = json[Key.keyAccessToken].stringValue
        token_type = json[Key.keyTokenType].stringValue
        expires_in = json[Key.keyExpiresIn].numberValue
    }
}

class JSONError: JSONDecodable {
    required init(json: JSON) throws {
        print("ERROR")
    }
}

//MARK: Enum that handles results
enum Result <T>{
    case Success(T)
    case Error(APIError<JSONError>)
}

//MARK: Protocol for testing purposes
protocol Gettable {
    associatedtype T
    func getBusinesses(search term: String, completion: @escaping (Result<T>) -> ())
    func getBusinessesFrom(selection: Selection, completion: @escaping (Result<T>) -> ())
}



























