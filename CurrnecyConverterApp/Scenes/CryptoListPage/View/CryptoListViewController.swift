//
//  CryptoListViewController.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 07.02.24.
//

import UIKit
import NetworkManager

final class CryptoListViewController: UIViewController {
    //MARK: - Properties
    private var tableView: UITableView!
    private var searchController: UISearchController!
    private var viewModel = CryptoListViewModel()
    private var filteredCryptos: [Crypto] = []
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - Methods
    private func setupUI () {
        setupTableView()
        
        viewModel.fetchCryptos { [weak self] in
            DispatchQueue.main.async {
                self?.filteredCryptos = self?.viewModel.cryptos ?? []
                self?.tableView.reloadData()
            }
        }
        setupSearchController()
        navigationItem.title = "Crypto"
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
       // tableView.allowsSelection = false
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: "CryptoCell")
        tableView.backgroundColor = UIColor.background
        view.addSubview(tableView)
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Crypto currencies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
}

//MARK: - Extension(TableView)
extension CryptoListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCryptos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath) as! CryptoTableViewCell
        let crypto = filteredCryptos[indexPath.row]
        let image = viewModel.image(for: crypto)
        cell.configure(with: crypto, image: image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let crypto = filteredCryptos[indexPath.row]
        let detailsVC = CryptoDetailsViewController()
        detailsVC.crypto = crypto
        detailsVC.cryptoImage = viewModel.image(for: crypto)
        navigationController?.pushViewController(detailsVC, animated: true)
    }

}

//MARK: - Extension(SearchController)
extension CryptoListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredCryptos = viewModel.cryptos.filter { crypto in
                return crypto.name.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredCryptos = viewModel.cryptos
        }
        tableView.reloadData()
    }
}
