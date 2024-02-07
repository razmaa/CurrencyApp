//
//  CurrencyConverterViewModel.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 03.02.24.
//

import Foundation
import NetworkManager

final class CurrencyConverterViewModel: ObservableObject {
    //MARK: - Properties
    @Published var conversionResult: String = "0.0"
    @Published var historicalConversion: String?
    @Published var currencies: [String] = []
    @Published var selectedDate = Date()
    
    private let networkManager = GenericNetworkManager(baseURL: "https://api.frankfurter.app")
    
    //MARK: - init
    init() {
        fetchCurrencies()
    }
    
    //MARK: - Methods
    func fetchCurrencies() {
        networkManager.fetchData(endpoint: "/currencies") { (result: Result<[String: String], Error>) in
            switch result {
            case .success(let decodedResponse):
                DispatchQueue.main.async {
                    self.currencies = Array(decodedResponse.keys).sorted()
                }
            case .failure(let error):
                print("Failed to fetch currencies: \(error)")
            }
        }
    }
    
    func convert(amount: String, from: String, to: String) {
        let expression = NSExpression(format: amount)
        guard let amountValue = expression.expressionValue(with: nil, context: nil) as? Double else {
            self.conversionResult = "Invalid input. Please enter a valid number."
            return
        }
        
        guard amountValue >= 0 else {
            self.conversionResult = "Invalid input. The amount cannot be negative."
            return
        }
        
        guard !amount.isEmpty, let amountValue = Double(amount) else {
            self.conversionResult = "Invalid input. Please enter a valid number."
            return
        }
        
        let endpoint = "/latest?from=\(from)&to=\(to)"
        networkManager.fetchData(endpoint: endpoint) { (result: Result<CurrencyResponse, Error>) in
            switch result {
            case .success(let rate):
                guard let conversionRate = rate.rates[to] else {
                    self.conversionResult = "Conversion rate not available."
                    return
                }
                
                DispatchQueue.main.async {
                    let result = amountValue * conversionRate
                    self.conversionResult = String(format: "%.2f", result)
                }
            case .failure(let error):
                self.conversionResult = "\(error.localizedDescription)"
            }
        }
    }
    
    func convertHistorical(amount: String, from: String, to: String, date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        let expression = NSExpression(format: amount)
        guard let amountValue = expression.expressionValue(with: nil, context: nil) as? Double else {
            self.historicalConversion = "Invalid input. Please enter a valid number."
            return
        }
        
        guard amountValue >= 0 else {
            self.historicalConversion = "Invalid input. The amount cannot be negative."
            return
        }
        
        guard !amount.isEmpty, let amountValue = Double(amount) else {
            self.historicalConversion = "Invalid input. Please enter a valid number."
            return
        }
        
        let endpoint = "/\(dateString)?from=\(from)&to=\(to)"
        networkManager.fetchData(endpoint: endpoint) { (result: Result<CurrencyResponse, Error>) in
            switch result {
            case .success(let rate):
                guard let conversionRate = rate.rates[to] else {
                    self.historicalConversion = "Conversion rate not available."
                    return
                }
                
                DispatchQueue.main.async {
                    let result = amountValue * conversionRate
                    self.historicalConversion = String(format: "%.2f", result)
                }
            case .failure(let error):
                self.conversionResult = "An error occurred: \(error.localizedDescription)"
            }
        }
    }
}
