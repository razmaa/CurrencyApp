//
//  CurrencyConverterViewModel.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 03.02.24.
//

import Foundation
import NetworkManager

class CurrencyConverterViewModel: ObservableObject {
    @Published var conversionResult: String = "0.0"
    @Published var historicalConversion: String?
    @Published var currencies: [String] = []
    @Published var selectedDate = Date()
    
    private let networkManager = GenericNetworkManager(baseURL: "https://api.frankfurter.app")
    
    init() {
        fetchCurrencies()
    }
    
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
        // Check if the amount is a valid number
        let expression = NSExpression(format: amount)
        guard let amountValue = expression.expressionValue(with: nil, context: nil) as? Double else {
            self.conversionResult = "Invalid input. Please enter a valid number."
            return
        }
        
        // Check if the amount is not negative
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
                // Check if the conversion rate is available
                guard let conversionRate = rate.rates[to] else {
                    self.conversionResult = "Conversion rate not available."
                    return
                }
                
                DispatchQueue.main.async {
                    let result = amountValue * conversionRate
                    self.conversionResult = String(format: "%.2f", result)
                }
            case .failure(let error):
                // Handle the error
                self.conversionResult = "\(error.localizedDescription)"
            }
        }
    }
    
    func convertHistorical(amount: String, from: String, to: String, date: Date) {
        // Format the date as required by the API
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        let expression = NSExpression(format: amount)
        guard let amountValue = expression.expressionValue(with: nil, context: nil) as? Double else {
            self.historicalConversion = "Invalid input. Please enter a valid number."
            return
        }
        
        // Check if the amount is not negative
        guard amountValue >= 0 else {
            self.historicalConversion = "Invalid input. The amount cannot be negative."
            return
        }
        
        // Check if the amount is not empty and is a valid number
        guard !amount.isEmpty, let amountValue = Double(amount) else {
            self.historicalConversion = "Invalid input. Please enter a valid number."
            return
        }
        
        let endpoint = "/\(dateString)?from=\(from)&to=\(to)"
        networkManager.fetchData(endpoint: endpoint) { (result: Result<CurrencyResponse, Error>) in
            switch result {
            case .success(let rate):
                // Check if the conversion rate is available
                guard let conversionRate = rate.rates[to] else {
                    self.historicalConversion = "Conversion rate not available."
                    return
                }
                
                DispatchQueue.main.async {
                    let result = amountValue * conversionRate
                    self.historicalConversion = String(format: "%.2f", result)
                }
            case .failure(let error):
                // Handle the error
                self.conversionResult = "An error occurred: \(error.localizedDescription)"
            }
        }
    }
    
}
