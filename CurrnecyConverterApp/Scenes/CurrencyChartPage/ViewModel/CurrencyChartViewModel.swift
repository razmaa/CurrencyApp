//
//  CurrencyChartViewModel.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 01.02.24.
//

import UIKit
import NetworkManager
import DGCharts

class CurrencyChartViewModel {
    var networkManager: GenericNetworkManager?
    var targetCurrencies: [String] = []

    init() {
        networkManager = GenericNetworkManager(baseURL: "https://www.frankfurter.app/")
        
        fetchAllCurrencies { result in
                    switch result {
                    case .success(_):
                        print("Successfully fetched all currencies.")
                    case .failure(let error):
                        print("Failed to fetch currencies: \(error)")
                    }
                }
    }
    
    func fetchAllCurrencies(completion: @escaping (Result<[String: String], Error>) -> Void) {
         let endpoint = "/currencies"
         
         networkManager?.fetchData(endpoint: endpoint) { (result: Result<[String: String], Error>) in
             switch result {
             case .success(let currencies):
                 self.targetCurrencies = Array(currencies.keys)
                 completion(.success(currencies))
             case .failure(let error):
                 print("Failed to fetch currencies: \(error)")
                 completion(.failure(error))
             }
         }
     }
    
    func fetchDataAndUpdateChart(for period: String, baseCurrency: String, targetCurrency: String, completion: @escaping (LineChartData?) -> Void) {
        // Define the start and end dates for the API request
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let endDate = Date()
        let startDate: Date
        switch period {
        case "1 WEEK":
            startDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: endDate)!
        case "1 MONTH":
            startDate = Calendar.current.date(byAdding: .month, value: -1, to: endDate)!
        case "1 YEAR":
            startDate = Calendar.current.date(byAdding: .year, value: -1, to: endDate)!
        default:
            return
        }
        let start_date = dateFormatter.string(from: startDate)
        let end_date = dateFormatter.string(from: endDate)
        
        let endpoint = "/\(start_date)..\(end_date)?from=\(baseCurrency)&to=\(targetCurrency)"
                
        networkManager?.fetchData(endpoint: endpoint) { (result: Result<ExchangeRateTimeSeries, Error>) in
            switch result {
            case .success(let exchangeRateTimeSeries):
                // Convert the exchange rate time series data to chart data
                let chartData = self.convertToChartData(exchangeRateTimeSeries: exchangeRateTimeSeries, target: targetCurrency)
                completion(chartData)
            case .failure(let error):
                print("Failed to fetch data: \(error)")
                completion(nil)
            }
        }
    }
    
    func convertToChartData(exchangeRateTimeSeries: ExchangeRateTimeSeries, target: String) -> LineChartData {
        // Convert the exchange rate time series data to chart data
        var dataEntries: [ChartDataEntry] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.date(from: exchangeRateTimeSeries.start_date)!

        for (date, rates) in exchangeRateTimeSeries.rates {
            let value = rates[target] ?? 0
            let currentDate = dateFormatter.date(from: date)!
            let days = Calendar.current.dateComponents([.day], from: startDate, to: currentDate).day!
            let dataEntry = ChartDataEntry(x: Double(days), y: value)
            dataEntries.append(dataEntry)
        }
        // Subtract the smallest x-value from all x-values
        if let minX = dataEntries.map({ $0.x }).min() {
            for i in 0..<dataEntries.count {
                dataEntries[i].x -= minX
            }
        }
        // Sort the data entries by their x-values
        dataEntries.sort(by: { $0.x < $1.x })
        
        let dataSet = LineChartDataSet(entries: dataEntries)
        dataSet.colors = [UIColor.systemPurple]
        dataSet.drawValuesEnabled = false
        dataSet.drawCirclesEnabled = false
        
        return LineChartData(dataSet: dataSet)
    }
}
