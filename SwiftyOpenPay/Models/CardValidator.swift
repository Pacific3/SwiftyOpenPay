//
//  CardValidator.swift
//  SwiftyOpenPay
//
//  Created by Oscar Swanros on 1/12/16.
//  Copyright © 2016 Pacific3. All rights reserved.
//

extension Card.CardType {
    internal var regex: String {
        switch self {
        case .Visa: return "^4[0-9]{12}(?:[0-9]{3})?$"
        case .MasterCard: return "^5[1-5][0-9]{14}$"
        case .Amex: return "^3[47][0-9]{13}$"
        case .Unknown: return ""
        }
    }
}

internal struct CardValidator {
    enum CardValidationError: ErrorType {
        case InvalidCard
    }
    
    static func validateCard(card: Card) throws {
        guard card.securityCodeCheckStatus == .Passed && card.expired == false else {
            throw CardValidationError.InvalidCard
        }
        
        guard let _ = card.number.rangeOfString(card.cardType.regex, options: .RegularExpressionSearch) else {
            throw CardValidationError.InvalidCard
        }
    }
}
