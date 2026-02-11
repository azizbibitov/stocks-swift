//
//  NetworkManager.swift
//  StocksSnapKit
//
//  Created by Aziz Bibitov on 06/08/2025.
//

import Foundation

/// Custom error types for network operations
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case apiError(String)
    case decodingError(Error)
    case rateLimitExceeded
    case invalidAPIKey
    case networkError(Error)
}

/// Manager class responsible for handling network requests
final class NetworkManager {
    
    // MARK: - Properties
    
    /// Shared instance for singleton access
    static let shared = NetworkManager()
    
    /// Base URL for the API
    private let baseURL = "https://finnhub.io/api/v1"
    
    /// API key for authentication
    private let apiKey = "d29gk21r01qhoenc27dgd29gk21r01qhoenc27e0" // Replace with your actual Finnhub API key
    
    /// URLSession for making network requests
    private let session: URLSession
    
    // MARK: - Initialization
    
    private init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.timeoutIntervalForRequest = 30
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Public Methods
    
    /// Fetches stock data for a given symbol
    /// - Parameters:
    ///   - symbol: The stock symbol to fetch data for (e.g., "AAPL")
    ///   - completion: Completion handler with Result type containing either Stock or NetworkError
    func getStockData(symbol: String, completion: @escaping (Result<Stock, NetworkError>) -> Void) {
        let endpoint = "/quote"
        guard var urlComponents = URLComponents(string: baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "symbol", value: symbol),
            URLQueryItem(name: "token", value: apiKey)
        ]
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                self?.handleSuccessResponse(data: data, symbol: symbol, completion: completion)
                
            case 401:
                completion(.failure(.invalidAPIKey))
            case 429:
                completion(.failure(.rateLimitExceeded))
            default:
                completion(.failure(.apiError("Status code: \(httpResponse.statusCode)")))
            }
        }
        
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func handleSuccessResponse(data: Data, symbol: String, completion: @escaping (Result<Stock, NetworkError>) -> Void) {
        do {
            // First decode the raw response
            let rawResponse = try JSONDecoder().decode(QuoteResponse.self, from: data)
            
            // Create a Stock object from the raw response
            let stock = Stock(
                companyName: symbol, // We'll need to make another API call to get the company name
                stockTicker: symbol,
                currentPrice: rawResponse.currentPrice,
                priceChange: rawResponse.change,
                percentageChange: rawResponse.percentChange,
                logoURL: "" // We'll need to make another API call to get the logo URL
            )
            
            completion(.success(stock))
        } catch {
            completion(.failure(.decodingError(error)))
        }
    }
}

// MARK: - API Response Models

/// Model representing the raw quote response from the API
private struct QuoteResponse: Codable {
    let currentPrice: Double
    let change: Double
    let percentChange: Double
    
    enum CodingKeys: String, CodingKey {
        case currentPrice = "c"
        case change = "d"
        case percentChange = "dp"
    }
}