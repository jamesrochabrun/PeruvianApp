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
    
    //MARK: GET BUSINESSES FROM SELECTION
    typealias SearchBusinessFromCategoriesCompletionHandler = (Result<BusinessViewModelDataSource>) -> ()
    func getBusinessesFrom(selection: Selection, completionQueue: DispatchQueue, completion: @escaping SearchBusinessFromCategoriesCompletionHandler) {
        
        let request: APIRequest<BusinessViewModelDataSource, JSONError> = tron.request(YelpEndpoint.searchBusinesses.path)
        request.headers = YelpHeader.authorization.headers
        request.parameters = YelpParameter.nearbyFrom(selection: selection).paramaters
        request.perform(withSuccess: { (businessDataSource) in
            completionQueue.async {
                completion(.Success(businessDataSource))
            }
        }, failure: { (error) in
            completion(.Error(error))
        })
    }
    
    //MARK: GET BUSINESS FROM ID
    typealias SearchBusinessFromIDCompletion = (Result<Business>) -> ()
    func getBusinessWithID(_ id: String, completionQueue: DispatchQueue, completion: @escaping SearchBusinessFromIDCompletion) {
        
        let request: APIRequest<Business, JSONError> = tron.request(YelpEndpoint.searchWith(id: id).path)
        request.headers = YelpHeader.authorization.headers
                
        request.perform(withSuccess: { (business) in
            completionQueue.async {
                completion(.Success(business))
            }
        }, failure: { (error) in
            completion(.Error(error))
        })
    }
    
    //MARK: GET BUSINESS REVIEW FROM ID
    typealias BusinessReviewsCompletion = (Result<ReviewsViewModelDataSource>) -> ()
    func getReviewsFrom(businessID id: String, completionQueue: DispatchQueue, completion: @escaping BusinessReviewsCompletion) {
        
        let request: APIRequest<ReviewsViewModelDataSource, JSONError> = tron.request(YelpEndpoint.reviews(id: id).path)
        request.headers = YelpHeader.authorization.headers
        
        request.perform(withSuccess: { (reviewsViewModel) in
            
            completionQueue.async {
                completion(.Success(reviewsViewModel))
            }
        }, failure: { (error) in
            completion(.Error(error))
        })
    }
    
    //MARK: GET AUTOCOMPLETE RESPONSE
    typealias AutoCompleteCompletion = (Result<AutoCompleteResponse>) -> ()
    func getAutoCompleteResponseFrom(selection: Selection, completionQueue: DispatchQueue, completion: @escaping AutoCompleteCompletion) {
        
        let request: APIRequest<AutoCompleteResponse, JSONError> = tron.request(YelpEndpoint.autoComplete.path)
        request.headers = YelpHeader.authorization.headers
        request.parameters = YelpParameter.searchFrom(selection: selection).paramaters
        
        request.perform(withSuccess: { (autoCompleteResponse) in
            completionQueue.async {
                completion(.Success(autoCompleteResponse))
            }
        }, failure: { (error) in
            completion(.Error(error))
        })
    }
    
    //MARK: GET TOKEN
    typealias TokenCompletionhandler = (Result<Token>) -> ()
    func getToken(completionQueue: DispatchQueue, completion: @escaping TokenCompletionhandler) {
        
        let request: APIRequest<Token, JSONError> = tron.request(YelpEndpoint.token.path)
        request.method = .post
        request.parameters = YelpParameter.token.paramaters
        request.headers = YelpHeader.contentType.headers
        
        request.perform(withSuccess: { (token) in
            completionQueue.async {
                completion(.Success(token))
            }
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
    func getBusinessesFrom(selection: Selection, completionQueue: DispatchQueue, completion: @escaping (Result<T>) -> ())
}
























