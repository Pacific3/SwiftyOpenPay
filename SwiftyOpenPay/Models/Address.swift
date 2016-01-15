//
//  Card.swift
//  SwiftyOpenPay
//
//  Created by Oscar Swanros on 1/12/16.
//  Copyright © 2016 Pacific3. All rights reserved.
//

public struct Address: JSONParselable {
    public let city: String
    public let countryCode: String
    public let postalCode: String
    public let line1: String
    public let line2: String?
    public let line3: String?
    public let state: String
    
    public func backingData() -> [String:AnyObject] {
        return [
            "city": city,
            "country_code": countryCode,
            "postal_code": postalCode,
            "line1": line1,
            "line2": line2 ?? "",
            "line3": line3 ?? "",
            "state": state
        ]
    }
    
    public init() {
        city = ""
        postalCode = ""
        countryCode = ""
        line1 = ""
        line2 = nil
        line3 = nil
        state = ""
    }
    
    public init(
        line1: String,
        line2: String? = nil,
        line3: String? = nil,
        city: String,
        state: String,
        countryCode: String,
        postalCode: String
        )
    {
        self.city = city
        self.countryCode = countryCode
        self.postalCode = postalCode
        self.line1 = line1
        self.line2 = line2
        self.line3 = line3
        self.state = state
    }
    
    public static func withData(data: [String : AnyObject]) -> Address? {
        guard
            let city        = string(data, key: "city"),
            let countryCode = string(data, key: "country_code"),
            let postalCode  = string(data, key: "postal_code"),
            let line1       = string(data, key: "line1"),
            let state       = string(data, key: "state")
            else {
                return nil
        }
        
        let line2 = string(data, key: "line2")
        let line3 = string(data, key: "line3")
        
        return Address(
            line1: line1,
            line2: line2,
            line3: line3,
            city: city,
            state: state,
            countryCode: countryCode,
            postalCode: postalCode
        )
    }
}

