//
//  StockListViewController.swift
//  StocksSnapKit
//
//  Created by Aziz Bibitov on 06/08/2025.
//

import UIKit
import SnapKit

/// View controller responsible for displaying the list of stocks
class StockListViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The table view for displaying stocks
    private let tableView = UITableView()
    
    /// Array to hold the stock data
    private var stocks: [Stock] = []
    
    /// Cell identifier for reuse
    private let cellIdentifier = "StockTableViewCell"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    // MARK: - UI Setup
    
    /// Sets up the basic UI elements
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Stocks"
        
        // Add table view to view hierarchy
        view.addSubview(tableView)
        
        // Set up table view constraints using SnapKit
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// Configures the table view
    private func setupTableView() {
        // Set data source and delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        // Register the custom cell
        tableView.register(StockTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        // Configure table view appearance
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        tableView.estimatedRowHeight = 80
        
        // Remove extra separators
        tableView.tableFooterView = UIView()
        loadStockData()
    }
    
    // MARK: - Data Loading
    
    /// Loads stock data from the network
    private func loadStockData() {
        // This will be implemented in subtask 3.3
        // For now, we'll use mock data to test the UI
        loadMockData()
    }
    
    /// Loads mock data for testing purposes
    private func loadMockData() {
        stocks = [
            Stock(
                companyName: "Apple Inc.",
                stockTicker: "AAPL",
                currentPrice: 150.25,
                priceChange: 2.50,
                percentageChange: 1.69,
                logoURL: "https://logo.clearbit.com/apple.com"
            ),
            Stock(
                companyName: "Microsoft Corporation",
                stockTicker: "MSFT",
                currentPrice: 310.80,
                priceChange: -1.20,
                percentageChange: -0.38,
                logoURL: "https://logo.clearbit.com/microsoft.com"
            ),
            Stock(
                companyName: "Tesla, Inc.",
                stockTicker: "TSLA",
                currentPrice: 245.67,
                priceChange: 12.45,
                percentageChange: 5.34,
                logoURL: "https://logo.clearbit.com/tesla.com"
            )
        ]
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource

extension StockListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StockTableViewCell else {
            return UITableViewCell()
        }
        
        let stock = stocks[indexPath.row]
        cell.configure(with: stock)
        
        // Alternate background colors
        cell.backgroundColor = indexPath.row % 2 == 0 ? .systemBackground : UIColor.systemGray6
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension StockListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle cell selection - will be implemented later
    }
}
