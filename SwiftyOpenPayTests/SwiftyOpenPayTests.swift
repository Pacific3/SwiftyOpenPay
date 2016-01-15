//
//  SwiftyOpenPayTests.swift
//  SwiftyOpenPay
//
//  Created by Oscar Swanros on 1/15/16.
//  Copyright © 2016 Pacific3. All rights reserved.
//

import XCTest
@testable import SwiftyOpenPay

class SwiftyOpenPaytests: XCTestCase {
    func testBuildTokenFromServerResponse() {
        let response = [
            "id": "token_id",
            "card": [
                "address": [
                    "city": "Cupertino",
                    "country_code": "US",
                    "line1": "1 Infinite Loop",
                    "line2": "",
                    "line3": "",
                    "postal_code": "95014",
                    "state": "California"
                ],
                "brand": "visa",
                "card_number": "411111XXXXXX1111",
                "creation_date": "<null>",
                "expiration_month": "12",
                "expiration_year": "19",
                "holder_name": "John Doe"
            ]
        ]
        
        guard let token = buildToken(Token.self, data: response) else {
            assertionFailure("Could not build token")
            return
        }
        
        print(token.id)
    }
    
    func buildToken<T: JSONParselable>(type: T.Type, data: [String:AnyObject]) -> T? {
        return T.withData(data)
    }
}