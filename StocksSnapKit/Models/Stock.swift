//
//  Stock.swift
//  StocksSnapKit
//
//  Created by Aziz Bibitov on 06/08/2025.
//

import Foundation

/// A model representing stock data received from the API
struct Stock: Codable {
    /// The name of the company
    let companyName: String
    
    /// The stock ticker symbol (e.g., "AAPL" for Apple)
    let stockTicker: String
    
    /// The current stock price
    let currentPrice: Double
    
    /// The absolute price change (positive or negative)
    let priceChange: Double
    
    /// The percentage price change (positive or negative)
    let percentageChange: Double
    
    /// URL string for the company logo
    let logoURL: String
    
    /// Computed property to determine if the stock price has increased
    var isPriceUp: Bool {
        return priceChange >= 0
    }
    
    /// Formatted current price string with currency symbol
    var formattedPrice: String {
        return String(format: "$%.2f", currentPrice)
    }
    
    /// Formatted change string with sign and percentage
    var formattedChange: String {
        let sign = isPriceUp ? "+" : ""
        return String(format: "%@%.2f (%.2f%%)", sign, priceChange, percentageChange)
    }
    
    /// Formatted price change string with sign and currency symbol
    var formattedPriceChange: String {
        return String(format: "%+.2f", priceChange)
    }
    
    /// Formatted percentage change string with sign and % symbol
    var formattedPercentageChange: String {
        return String(format: "%+.2f%%", percentageChange)
    }
    
    enum CodingKeys: String, CodingKey {
        case companyName = "companyName"
        case stockTicker = "symbol"
        case currentPrice = "price"
        case priceChange = "change"
        case percentageChange = "changePercent"
        case logoURL = "logo"
    }
}
