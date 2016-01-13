//
//  Token.swift
//  SwiftyOpenPay
//
//  Created by Oscar Swanros on 1/12/16.
//  Copyright © 2016 Pacific3. All rights reserved.
//

public struct Token: JSONParselable {
    public let id: String
    public let card: Card
    
    public init(id: String, card: Card) {
        self.id = id
        self.card = card
    }
    
    public func backingData() -> [String:AnyObject] {
        return [
            "id": id,
            "card": card.backingData()
        ]
    }
    
    public static func withData(data: [String : AnyObject]) -> Token? {
        guard
            let id = string(data, key: "id"),
            let cardData = data["card"] as? [String:AnyObject] else {
                return nil
        }
        
        guard let card = Card.withData(cardData) else {
            return nil
        }
        
        return Token(id: id, card: card)
    }
}
