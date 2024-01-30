//
//  CurrenciesListViewController.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 22.01.24.
//

import UIKit

class CurrenciesListViewController: UIViewController {
    //MARK: - Properties
    
    private var viewModel = CurrencyViewModel()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchLatestRates()
        tableView.reloadData()
    }
    
    //MARK: - Methods
    private func setupUI() {
        self.title = "Currencies"
        view.backgroundColor = .background
        
        setupTableView()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .background
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: "CurrencyCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    @objc func addButtonTapped() {
        let allCurrenciesViewController = AllCurrenciesViewController(viewModel: viewModel)
        navigationController?.pushViewController(allCurrenciesViewController, animated: true)
    }
    
    @objc func baseCurrencyChanged(_ sender: UISegmentedControl) {
        viewModel.baseCurrency = viewModel.selectedCurrencies[sender.selectedSegmentIndex]
        viewModel.fetchLatestRates()
        tableView.reloadData()
    }
    
}

//MARK: - Extensions

extension CurrenciesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.selectedCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
        
        if indexPath.row < viewModel.selectedCurrencies.count {
            let currencyCode = viewModel.selectedCurrencies[indexPath.row]
            let currencyRate = viewModel.currencyData[currencyCode]
            cell.currencyCodeLabel.text = currencyCode
            cell.currencyValueLabel.text = String(format: "%.3f", currencyRate ?? 1)
            cell.baseCurrencyButton.isSelected = (currencyCode == viewModel.baseCurrency)
            cell.onBaseCurrencyButtonTapped = { [weak self] in
                self?.viewModel.updateBaseCurrency(to: currencyCode)
                tableView.reloadData()
            }
            
            viewModel.fetchFlagForCountryCode(currencyCode) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        cell.flagImageView.image = image
                    }
                case .failure(let error):
                    print("Error fetching flag: \(error)")
                }
            }
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currencyCode = viewModel.selectedCurrencies[indexPath.row]
            if let index = viewModel.selectedCurrencies.firstIndex(of: currencyCode) {
                viewModel.selectedCurrencies.remove(at: index)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
}
