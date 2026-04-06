//
//  Portfolio.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 04/04/26.
//

import SwiftData

@Model
final class Portfolio {
    var coinID: String
    var amount: Double
    
    init(coinID: String, amount: Double) {
        self.coinID = coinID
        self.amount = amount
    }
}
