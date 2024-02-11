//
//  CurrenciesListViewModel.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 22.01.24.
//

import NetworkManager
import UIKit

final class CurrencyViewModel {
    //MARK: - Properties
    private let currencyNetworkManager = GenericNetworkManager(baseURL: "https://api.frankfurter.app")
    private let flagNetworkManager = GenericNetworkManager(baseURL: "https://flagsapi.com")
    private var timer: Timer?
    var currencyData: [String: Double] = [:]
    var selectedCurrencies: [String] = ["USD", "GBP", "AUD", "TRY", "JPY"]
    var baseCurrency: String = "EUR"
    
    private let currencyToCountryCode: [String: String] = [
        "AUD": "AU", // Australia
        "BGN": "BG", // Bulgaria
        "BRL": "BR", // Brazil
        "CAD": "CA", // Canada
        "CHF": "CH", // Switzerland
        "CNY": "CN", // China
        "CZK": "CZ", // Czech Republic
        "DKK": "DK", // Denmark
        "GBP": "GB", // United Kingdom
        "HKD": "HK", // Hong Kong
        "HUF": "HU", // Hungary
        "IDR": "ID", // Indonesia
        "ILS": "IL", // Israel
        "INR": "IN", // India
        "ISK": "IS", // Iceland
        "JPY": "JP", // Japan
        "KRW": "KR", // South Korea
        "MXN": "MX", // Mexico
        "MYR": "MY", // Malaysia
        "NOK": "NO", // Norway
        "NZD": "NZ", // New Zealand
        "PHP": "PH", // Philippines
        "PLN": "PL", // Poland
        "RON": "RO", // Romania
        "SEK": "SE", // Sweden
        "SGD": "SG", // Singapore
        "THB": "TH", // Thailand
        "TRY": "TR", // Turkey
        "USD": "US", // United States
        "ZAR": "ZA"  // South Africa
    ]
    
    //MARK: - init
    init() {
        if let data = UserDefaults.standard.data(forKey: "CurrencyData"),
           let savedCurrencyData = try? JSONDecoder().decode([String: Double].self, from: data) {
            currencyData = savedCurrencyData
        } else {
            currencyData = [:]
        }
        
        fetchLatestRates(completion: {})
        
        timer = Timer.scheduledTimer(withTimeInterval: 1800, repeats: true) { [weak self] _ in
            self?.fetchLatestRates(completion: {})
        }
    }
    
    //MARK: - Methods
    func fetchLatestRates(completion: @escaping () -> Void) {
        let filteredCurrencies = selectedCurrencies.filter { $0 != baseCurrency }
        let selectedCurrenciesString = filteredCurrencies.joined(separator: ",")
        currencyNetworkManager.fetchData(endpoint: "/latest?from=\(baseCurrency)&to=\(selectedCurrenciesString)") { [weak self] (result: Result<CurrencyResponse, Error>) in
            switch result {
            case .success(let data):
                self?.currencyData = data.rates
                let data = try? JSONEncoder().encode(self?.currencyData)
                UserDefaults.standard.set(data, forKey: "CurrencyData")
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
            completion()
        }
    }

    func fetchAllCurrencies(completion: @escaping (Result<CurrencyResponse, Error>) -> Void) {
        currencyNetworkManager.fetchData(endpoint: "/latest", completion: completion)
    }
    
    func addCurrency(_ currency: String) {
        if !selectedCurrencies.contains(currency) {
            selectedCurrencies.append(currency)
        }
    }
    
    func updateBaseCurrency(to newBaseCurrency: String) {
        baseCurrency = newBaseCurrency
        fetchLatestRates(completion: {})
    }
    
    func getCountryCode(from currencyCode: String) -> String? {
        return currencyToCountryCode[currencyCode]
    }
    
    func fetchFlagForCountryCode(_ currencyCode: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let countryCode = getCountryCode(from: currencyCode) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get country code from currency code"])))
            return
        }
        
        let flagEndpoint = "/\(countryCode)/flat/64.png"
        flagNetworkManager.fetchImage(endpoint: flagEndpoint, completion: completion)
    }
    
    func flagEmoji(for countryCode: String) -> String {
        let base: UInt32 = 127397
        var s = ""
        for v in countryCode.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }
}
