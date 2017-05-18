//
//  Token.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/18/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import TRON
import SwiftyJSON

struct Token: JSONDecodable {
    
    let access_token: String
    let token_type: String
    let expires_in: NSNumber
}

extension Token {
    
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
