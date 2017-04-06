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
    static let sharedInstance = YelpService()
    let tron = TRON(baseURL: "https://api.yelp.com/")
    
    //MARK: TypeAliases
    typealias SearchBusinessCompletionHandler = (Result<BusinessDataSource>) -> ()
    typealias TokenCompletionhandler = (Result<Token>) -> ()
    
    func getBusiness(search term: String, completion: @escaping SearchBusinessCompletionHandler) {
        
        let request: APIRequest<BusinessDataSource, JSONError> = tron.request("v3/businesses/search")
        request.headers = ["Authorization": "Bearer \(accessToken)"]
        request.parameters = ["term" : term,
                              "latitude" : "37.785771",
                              "longitude" : "-122.406165"]
        
        request.perform(withSuccess: { (businessDataSource) in
            completion(.Success(businessDataSource))
        }, failure: { (error) in
            completion(.Error(error))
        })
    }
    
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

enum Result <T>{
    case Success(T)
    case Error(APIError<JSONError>)
}

protocol Gettable {
    associatedtype T
    func getBusiness(search term: String, completion: @escaping (Result<T>) -> ())
}

enum ReviewIcon: NSNumber {
    
    case oneStar
    case oneAndHalfStar
    case twoStar
    case twoAndHalfStar
    case threeStar
    case threeAndHalfStar
    case fourStar
    case fourAndHalfStar
    case fiveStar
    case fiveAndHalfStar
    case unexpectedReview
    
    init(reviewNumber: NSNumber) {
        switch reviewNumber {
        case 1 : self = .oneStar
        case 1.5: self = .oneAndHalfStar
        case 2 : self = .twoStar
        case 2.5 : self = .twoAndHalfStar
        case 3 : self = .threeStar
        case 3.5 : self = .threeAndHalfStar
        case 4 : self = .fourStar
        case 4.5 : self = .fourAndHalfStar
        case 5 : self = .fiveStar
        case 5.5 : self = .fiveAndHalfStar
        default: self = .unexpectedReview
        }
    }
}

extension ReviewIcon {
    var image : UIImage {
        switch self {
        case .oneStar: return UIImage()
        case .oneAndHalfStar: return UIImage()
        case .twoStar: return UIImage()
        case .twoAndHalfStar: return UIImage()
        case .threeStar: return UIImage()
        case .threeAndHalfStar: return UIImage()
        case .fourStar: return UIImage()
        case .fourAndHalfStar: return UIImage()
        case .fiveStar: return UIImage()
        case .fiveAndHalfStar: return UIImage()
        case .unexpectedReview: return UIImage()
        }
    }
}


























