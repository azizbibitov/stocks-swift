//
//  MainStocksVC.swift
//  StocksSnapKit
//
//  Created by Aziz Bibitov on 06/08/2025.
//

import Foundation
import UIKit
import SnapKit

class MainStocksVC: UIViewController {
    
    let button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .systemRed
        title = "Stocks"
        self.view.addSubview(button)
        button.setTitle("hitme", for: .normal)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        
    }
    
    @objc private func buttonTapped() {
        print("Button tapped!")
        self.navigationController?.pushViewController(TestieVC2(), animated: true)
    }
    
    private func setupStockListViewController() {
        let stockListVC = StockListViewController()
        
        // Add as child view controller
        addChild(stockListVC)
        view.addSubview(stockListVC.view)
        stockListVC.didMove(toParent: self)
        
        // Set up constraints
        stockListVC.view.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}

class TestieVC2: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyTableViewCell
        cell.configure(with: "Row \(indexPath.row + 1)")
        return cell
    }
    
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
}

class MyTableViewCell: UITableViewCell {
    
    private let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        label.text = text
    }
}

class TestieVC: UIViewController {
    
    private let spinner = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
        spinner.startAnimating()
        self.view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
}

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    private let tableView = UITableView()
    private var searchController: UISearchController!
    
    private let allItems = ["Apple", "Banana", "Orange", "Pineapple", "Mango", "Grapes", "Watermelon"]
    private var filteredItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Fruits"
        view.backgroundColor = .systemBackground
        definesPresentationContext = true
        
        // MARK: - Setup TableView
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // MARK: - Setup Search Controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search fruits"
        
        navigationItem.titleView = searchController.searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        
        filteredItems = allItems
    }
    
    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fruit = filteredItems[indexPath.row]
        self.navigationController?.pushViewController(FavoritesViewController(fruit: fruit), animated: true)
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            filteredItems = allItems
            tableView.reloadData()
            return
        }
        filteredItems = allItems.filter { $0.lowercased().contains(text.lowercased()) }
        tableView.reloadData()
    }
}

// MARK: - Another Example Screen
class FavoritesViewController: UIViewController {
    
    var fruit: String = "Favorites"
    
    init(fruit: String) {
        self.fruit = fruit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = fruit
        view.backgroundColor = .systemBlue
    }
}

// MARK: - Root TabBarController
class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create tabs
        let searchVC = SearchViewController()
        let favoritesVC = FavoritesViewController(fruit: "Favooor")
        
        // Embed in navigation controllers
        let nav1 = UINavigationController(rootViewController: searchVC)
        let nav2 = UINavigationController(rootViewController: favoritesVC)
        
        // Tab bar items
        nav1.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        nav2.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), tag: 1)
        
        viewControllers = [nav1, nav2]
    }
}
