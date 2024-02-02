//
//  AllCurrenciesViewController.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 30.01.24.
//

import UIKit

class AllCurrenciesViewController: UIViewController {
    //MARK: - Properties
    private var viewModel: CurrencyViewModel
    private var tableView: UITableView!

    //MARK: - init
    init(viewModel: CurrencyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: - Methods
    private func setupUI() {
        setupTableView()
        
        viewModel.fetchAllCurrencies { [weak self] result in
            switch result {
            case .success(let data):
                self?.viewModel.currencyData = data.rates
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching all currencies: \(error)")
            }
        }
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .background
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

}

//MARK: - Extension
extension AllCurrenciesViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currencyData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .background

        let currencyCode = Array(viewModel.currencyData.keys)[indexPath.row]
        cell.textLabel?.text = currencyCode
        cell.textLabel?.textColor = .primary
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currencyCode = Array(viewModel.currencyData.keys)[indexPath.row]
        if !viewModel.selectedCurrencies.contains(currencyCode) {
            viewModel.selectedCurrencies.append(currencyCode)
        }
        navigationController?.popViewController(animated: true)
    }


}

