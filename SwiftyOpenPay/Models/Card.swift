//
//  Card.swift
//  SwiftyOpenPay
//
//  Created by Oscar Swanros on 1/12/16.
//  Copyright © 2016 Pacific3. All rights reserved.
//

public struct Card: JSONParselable {
    public enum CardType {
        case Unknown
        case Visa
        case MasterCard
        case Amex
    }
    
    public enum SecurityCodeCheckStatus {
        case Unknown
        case Passed
        case Failed
    }
    
    public let holderName: String
    public let expirationMonth: String
    public let expirationYear: String
    public let address: Address
    public let number: String
    public let id: String?
    public let bankName: String?
    public let brand: String?
    public let cvv2: String?
    public let allowsCharges: Bool?
    public let allowsPayouts: Bool?
    
    public init(
        holderName: String,
        expirationMonth: String,
        expirationYear: String,
        address: Address,
        number: String,
        id: String?          = nil,
        bankName: String?    = nil,
        allowsPayouts: Bool? = nil,
        brand: String?       = nil,
        cvv2: String?        = nil,
        allowsCharges: Bool? = nil
        )
    {
        self.holderName = holderName
        self.expirationMonth = expirationMonth
        self.expirationYear = expirationYear
        self.address = address
        self.number = number
        self.id = id
        self.bankName = bankName
        self.allowsPayouts = allowsPayouts
        self.allowsCharges = allowsCharges
        self.brand = brand
        self.cvv2 = cvv2
    }
    
    public func backingData() -> [String:AnyObject] {
        return [
            "holder_name": holderName,
            "expiration_month": expirationMonth,
            "expiration_year": expirationYear,
            "address": address.backingData(),
            "number": number,
            "id": id ?? "",
            "bank_name": bankName ?? "",
            "allows_payouts": allowsPayouts ?? false,
            "allows_charges": allowsCharges ?? false,
            "brand": brand ?? "",
            "cvv2": cvv2 ?? ""
        ]
    }
    
    public static func withData(data: [String : AnyObject]) -> Card? {
        guard
            let id              = string(data, key: "id"),
            let bankName        = string(data, key: "bank_name"),
            let holderName      = string(data, key: "holder_name"),
            let expirationMonth = string(data, key: "expiration_month"),
            let expirationYear  = string(data, key: "expiration_year"),
            let number          = string(data, key: "card_number"),
            let brand           = string(data, key: "brand"),
            let allowsPayouts   = bool(data, key: "allows_payouts"),
            let allowsCharges   = bool(data, key: "allows_charges"),
            let addressData     = data["address"] as? [String:AnyObject]
            else {
                return nil
        }
        
        guard let address = Address.withData(addressData) else {
            return nil
        }
        
        return Card(
            holderName: holderName,
            expirationMonth: expirationMonth,
            expirationYear: expirationYear,
            address: address,
            number: number,
            id: id,
            bankName: bankName,
            allowsPayouts: allowsPayouts,
            brand: brand,
            cvv2: nil,
            allowsCharges: allowsCharges
        )
    }
    
    public var cardType: CardType {
        guard let digits = Int(number.substringToIndex(number.startIndex.successor())) else {
            return .Unknown
        }
        
        switch digits {
        case 40...49:
            return .Visa
            
        case 50...59:
            return .MasterCard
            
        case 34, 37:
            return .Amex
            
        default:
            return .Unknown
        }
    }
    
    public var expired: Bool {
        guard
            let expirationMonth = Int(expirationMonth),
            let expirationYear = Int(expirationYear) else {
                return true
        }
        
        if expirationMonth > 12 ||  expirationMonth < 1 { return true }
        
        let currentDateComponents = NSCalendar.currentCalendar().components([.Month, .Year], fromDate: NSDate())
        
        guard
            (expirationYear + 2000) <= currentDateComponents.year &&
                expirationMonth <= currentDateComponents.month
            else {
                return false
        }
        
        return true
    }
    
    public var securityCodeCheckStatus: SecurityCodeCheckStatus {
        guard cardType != .Unknown else {
            return .Unknown
        }
        
        let requiredLength = cardType == .Amex ? 4 : 3
        
        guard cvv2?.characters.count == requiredLength else {
            return .Failed
        }
        
        return .Passed
    }
    
    public func isValid() throws {
        try CardValidator.validateCard(self)
    }
}