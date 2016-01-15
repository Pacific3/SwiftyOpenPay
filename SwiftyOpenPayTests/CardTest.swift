//
//  CardTest.swift
//  SwiftyOpenPay
//
//  Created by Oscar Swanros on 1/15/16.
//  Copyright © 2016 Pacific3. All rights reserved.
//

import XCTest
@testable import SwiftyOpenPay

class CardTests: XCTestCase {
    var address: Address?
    var visaNumbers: [String]?
    var invalidNumbers: [String]?
    var masterCardNumbers: [String]?
    var amexNumbers: [String]?
    
    override func setUp() {
        address = Address(
            line1: "Koyotlan 230",
            city: "Villa de Álvarez",
            state: "Colima",
            countryCode: "MX",
            postalCode: "28979"
        )
        
        visaNumbers = [
            "4111111111111111",
            "4444444444444448",
            "4222222222222220",
            "4532418643138442",
            "4716314539050650",
            "4485498805067453",
            "4929679978342120",
            "4400544701105053"
        ]
        
        invalidNumbers = [
            "6011373997942482",
            "6011640053409402",
            "6011978682866778",
            "6011391946659189",
            "6011358300105877"
        ]
        
        masterCardNumbers = [
            "5105105105105100",
            "5549904348586207",
            "5151601696648220",
            "5421885505663975",
            "5377756349885534",
            "5346784314486086"
        ]
        
        amexNumbers = [
            "341111111111111",
            "340893849936650",
            "372036201733247",
            "378431622693837",
            "346313453954711",
            "341677236686203"
        ]
    }
    
    func testVisaNumbers() {
        for number in visaNumbers! {
            let myCard = Card(
                holderName: "John Doe",
                expirationMonth: "04",
                expirationYear: "19",
                address: address!,
                number: number
            )
            
            assert(myCard.cardType == .Visa)
        }
    }
    
    func testMasterCardNumbers() {
        for number in masterCardNumbers! {
            let myCard = Card(
                holderName: "John Doe",
                expirationMonth: "04",
                expirationYear: "19",
                address: address!,
                number: number
            )
            
            assert(myCard.cardType == .MasterCard)
        }
    }
    
    func testAmexNumbers() {
        for number in amexNumbers! {
            let myCard = Card(
                holderName: "John Doe",
                expirationMonth: "04",
                expirationYear: "19",
                address: address!,
                number: number
            )
            
            assert(myCard.cardType == .Amex)
        }
    }

    func testValidVisaCard() {
        for number in visaNumbers! {
            let myCard = Card(
                holderName: "John Doe",
                expirationMonth: "04",
                expirationYear: "19",
                address: address!,
                number: number,
                cvv2: "123"
            )
            
            do {
                try myCard.isValid()
            } catch {
                assertionFailure("Card with number \(myCard.number) is invalid.")
            }
        }
    }
    
    func testInvalidVisaCardExpired() {
        for number in visaNumbers! {
            let myCard = Card(
                holderName: "John Doe",
                expirationMonth: "04",
                expirationYear: "12",
                address: address!,
                number: number,
                cvv2: "123"
            )
            
            do {
                try myCard.isValid()
            } catch {
                assert(error as! CardValidator.CardValidationError == .InvalidCard)
            }
        }
    }
    
    func testValidMasterCardCard() {
        for number in masterCardNumbers! {
            let myCard = Card(
                holderName: "John Doe",
                expirationMonth: "04",
                expirationYear: "19",
                address: address!,
                number: number,
                cvv2: "123"
            )
            
            do {
                try myCard.isValid()
            } catch {
                assertionFailure("Card with number \(myCard.number) is invalid.")
            }
        }
    }
    
    func testInvalidMasterCardCardExpired() {
        for number in masterCardNumbers! {
            let myCard = Card(
                holderName: "John Doe",
                expirationMonth: "04",
                expirationYear: "12",
                address: address!,
                number: number,
                cvv2: "123"
            )
            
            do {
                try myCard.isValid()
            } catch {
                assert(error as! CardValidator.CardValidationError == .InvalidCard)
            }
        }
    }
    
}
