//
//  Double+Extension.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 27/03/26.
//

import Foundation

extension Double {
    /// Converts a Double into a Currency with 2 decimal places
    /// ```
    /// Convert 1234.56 to R$1.234,56
    /// ```
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    /// Converts a Double into a Currency as a String with 2 decimal places
    /// ```
    /// Convert 1234.56 to "R$1.234,56"
    /// ```
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "R$0,00"
    }
    
    /// Converts a Double into a Currency with 2-6 decimal places
    /// ```
    /// Convert 1234.56 to R$1.234,56
    /// Convert 12.3456 to R$12,3456
    /// Convert 0.123456 to R$0,123456
    /// ```
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        //formatter.locale = Locale(identifier: "pt_BR") // <- default value
        //formatter.currencyCode = "brl" // <- change currency
        //formatter.currencySymbol = "R$" // <- change currency symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    /// Converts a Double into a Currency as a String with 2-6 decimal places
    /// ```
    /// Convert 1234.56 to "R$1.234,56"
    /// Convert 12.3456 to "R$12,3456"
    /// Convert 0.123456 to "R$0,123456"
    /// ```
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "R$0,00"
    }
    
    /// Converts a Double into String represation
    /// ```
    /// Convert 1.23456 to "1,23"
    /// ```
    func asNumberString() -> String {
        return String(format: "%.2f", self).replacingOccurrences(of: ".", with: ",")
    }
    
    /// Converts a Double into String represation with percent symbol
    /// ```
    /// Convert 1.23456 to "1,23%"
    /// ```
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
}
