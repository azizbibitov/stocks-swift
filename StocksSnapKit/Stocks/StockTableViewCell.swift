//
//  StockTableViewCell.swift
//  StocksSnapKit
//
//  Created by Aziz Bibitov on 06/08/2025.
//

import UIKit
import SnapKit

/// Custom table view cell for displaying stock information
class StockTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    /// Company logo image view
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    /// Stock ticker label (e.g., "AAPL")
    private let tickerLabel: UILabel = {
        let label = UILabel()
        label.font = MontserratFonts.bold(size: 16)
        label.textColor = .label
        return label
    }()
    
    /// Company name label
    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = MontserratFonts.regular(size: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    /// Current price label
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = MontserratFonts.bold(size: 16)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()
    
    /// Price change label (with percentage)
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.font = MontserratFonts.medium(size: 14)
        label.textAlignment = .right
        return label
    }()
    
    /// Favorite button (star icon)
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.tintColor = .systemYellow
        return button
    }()
    
    // MARK: - Properties
    
    /// The stock data for this cell
    private var stock: Stock?
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    /// Sets up the UI elements and constraints
    private func setupUI() {
        selectionStyle = .none
        
        // Add subviews
        contentView.addSubview(logoImageView)
        contentView.addSubview(tickerLabel)
        contentView.addSubview(companyNameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(changeLabel)
        contentView.addSubview(favoriteButton)
        
        // This will be implemented in subtask 3.2
        setupConstraints()
    }
    
    /// Sets up the layout constraints using SnapKit
    private func setupConstraints() {
        // Logo constraints
        logoImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        // Ticker label constraints
        tickerLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoImageView.snp.trailing).offset(12)
            make.top.equalToSuperview().offset(12)
        }
        
        // Company name label constraints
        companyNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(tickerLabel)
            make.top.equalTo(tickerLabel.snp.bottom).offset(4)
            make.trailing.lessThanOrEqualTo(priceLabel.snp.leading).offset(-8)
        }
        
        // Favorite button constraints
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        // Price label constraints
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-12)
            make.top.equalToSuperview().offset(12)
        }
        
        // Change label constraints
        changeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(priceLabel)
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
        }
    }
    
    // MARK: - Configuration
    
    /// Configures the cell with stock data
    /// - Parameter stock: The stock data to display
    func configure(with stock: Stock) {
        self.stock = stock
        
        tickerLabel.text = stock.stockTicker
        companyNameLabel.text = stock.companyName
        priceLabel.text = stock.formattedPrice
        
        // Configure change label with color
        changeLabel.text = stock.formattedChange
        changeLabel.textColor = stock.isPriceUp ? .systemGreen : .systemRed
        
        // Load logo image - will be implemented in subtask 3.4
        loadLogo(from: stock.logoURL)
        
        // Configure favorite button - will be connected to favorites functionality later
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Image Loading
    
    /// Loads the company logo from URL
    /// - Parameter urlString: The URL string for the logo
    private func loadLogo(from urlString: String) {
        // This will be implemented in subtask 3.4 using Kingfisher
        // For now, set a placeholder
        logoImageView.image = UIImage(systemName: "building.2")
        logoImageView.tintColor = .systemGray
    }
    
    // MARK: - Actions
    
    /// Handles favorite button tap
    @objc private func favoriteButtonTapped() {
        favoriteButton.isSelected.toggle()
        // This will be connected to favorites functionality later
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.image = nil
        tickerLabel.text = nil
        companyNameLabel.text = nil
        priceLabel.text = nil
        changeLabel.text = nil
        favoriteButton.isSelected = false
        stock = nil
    }
}