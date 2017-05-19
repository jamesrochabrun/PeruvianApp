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
    
    //MARK: properties
    //MARK: singleton
    static let sharedInstance = YelpService()
    private init() {}
    //MARK: tron object
    let tron = TRON(baseURL: YelpEndpoint.base)
    
    //MARK: TypeAliases for completion Handlers
    typealias SearchBusinessCompletionHandler = (Result<BusinessViewModelDataSource>) -> ()
    typealias TokenCompletionhandler = (Result<Token>) -> ()
    typealias SearchBusinessFromCategoriesCompletionHandler = (Result<BusinessViewModelDataSource>) -> ()
    typealias SearchBusinessFromIDCompletion = (Result<Business>) -> ()
    typealias BusinessReviewsCompletion = (Result<ReviewsViewModelDataSource>) -> ()
    
    
    //MARK: GET BUSINESSES FROM SELECTION
    func getBusinessesFrom(selection: Selection, completion: @escaping SearchBusinessFromCategoriesCompletionHandler) {
        
        let request: APIRequest<BusinessViewModelDataSource, JSONError> = tron.request(YelpEndpoint.searchBusinesses.path)
        request.headers = YelpHeader.authorization.headers
        request.parameters = YelpParameter.nearbyFrom(selection: selection).paramaters
        request.perform(withSuccess: { (businessDataSource) in
            DispatchQueue.main.async {
                completion(.Success(businessDataSource))
            }
        }, failure: { (error) in
            completion(.Error(error))
        })
    }
    
    //MARK: GET BUSINESS FROM ID
    func getBusinessWithID(_ id: String, completion: @escaping SearchBusinessFromIDCompletion) {
        
        let request: APIRequest<Business, JSONError> = tron.request(YelpEndpoint.searchWith(id: id).path)
        request.headers = YelpHeader.authorization.headers
                
        request.perform(withSuccess: { (business) in
            DispatchQueue.main.async {
                completion(.Success(business))
            }
        }, failure: { (error) in
            completion(.Error(error))
        })
    }
    
    //MARK: GET BUSINESS REVIEW FROM ID
    func getReviewsFrom(businessID id: String, completion: @escaping BusinessReviewsCompletion) {
        
        let request: APIRequest<ReviewsViewModelDataSource, JSONError> = tron.request(YelpEndpoint.reviews(id: id).path)
        request.headers = YelpHeader.authorization.headers
        
        request.perform(withSuccess: { (reviewsViewModel) in
            DispatchQueue.main.async {
                completion(.Success(reviewsViewModel))
            }
        }, failure: { (error) in
            completion(.Error(error))
        })
    }
    
    //MARK: GET TOKEN
    func getToken(completion: @escaping TokenCompletionhandler) {
        
        let request: APIRequest<Token, JSONError> = tron.request(YelpEndpoint.token.path)
        request.method = .post
        request.parameters = YelpParameter.token.paramaters
        request.headers = YelpHeader.ContentType.headers
        
        request.perform(withSuccess: { (token) in
            completion(.Success(token))
        }, failure: { (err) in
            completion(.Error(err))
        })
    }
}

//MARK: Error model
struct JSONError: JSONDecodable {
    init(json: JSON) throws {
        print("ERROR ->", json)
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
    func getBusinessesFrom(selection: Selection, completion: @escaping (Result<T>) -> ())
}



























