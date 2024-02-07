//
//  CurrencyRatesWidget.swift
//  CurrencyRatesWidget
//
//  Created by nika razmadze on 05.02.24.
//

import WidgetKit
import SwiftUI

//MARK: - Provider
struct Provider: AppIntentTimelineProvider {
    
    static let currencyToCountryCode: [String: String] = [
        "AUD": "AU",
        "BGN": "BG",
        "BRL": "BR",
        "CAD": "CA",
        "CHF": "CH",
        "CNY": "CN",
        "CZK": "CZ",
        "DKK": "DK",
        "GBP": "GB",
        "HKD": "HK",
        "HUF": "HU",
        "IDR": "ID",
        "ILS": "IL",
        "INR": "IN",
        "ISK": "IS",
        "JPY": "JP",
        "KRW": "KR",
        "MXN": "MX",
        "MYR": "MY",
        "NOK": "NO",
        "NZD": "NZ",
        "PHP": "PH",
        "PLN": "PL",
        "RON": "RO",
        "SEK": "SE",
        "SGD": "SG",
        "THB": "TH",
        "TRY": "TR",
        "USD": "US",
        "ZAR": "ZA"
    ]
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), currencyData: CurrencyData())
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let baseCurrency = configuration.baseCurrency ?? "EUR"
        let currencyData = await fetchCurrencyData(baseCurrency: baseCurrency)
        return SimpleEntry(date: Date(), configuration: configuration, currencyData: currencyData)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let currentDate = Date()
        let baseCurrency = configuration.baseCurrency ?? "EUR"
        let currencyData = await fetchCurrencyData(baseCurrency: baseCurrency)
        let entry = SimpleEntry(date: currentDate, configuration: configuration, currencyData: currencyData)
        return Timeline(entries: [entry], policy: .atEnd)
    }
    
    
    private func fetchCurrencyData(baseCurrency: String = "EUR") async -> CurrencyData {
        let url = URL(string: "https://api.frankfurter.app/latest?from=\(baseCurrency)")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let currencyData = try JSONDecoder().decode(CurrencyData.self, from: data)
            return currencyData
        } catch {
            print("Failed to fetch data: \(error)")
            return CurrencyData()
        }
    }
}

//MARK: - Model
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let currencyData: CurrencyData
}

struct CurrencyData: Decodable {
    let rates: [String: Double]
    
    init(rates: [String: Double] = [:]) {
        self.rates = rates
    }
}

//MARK: - View
struct CurrencyRatesWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    let preferredCurrencies = ["USD", "JPY", "GBP", "AUD", "CAD"]
    
    var body: some View {
        ZStack {
            Color("AccentColor")
            
            VStack{
                ForEach(entry.currencyData.rates.filter { preferredCurrencies.contains($0.key) && $0.key != entry.configuration.baseCurrency }.prefix(widgetFamily == .systemMedium ? 2 : 4), id: \.key) { key, value in
                    CurrencyRateRow(key: key, value: value)
                }
            }
            .padding()
        }
    }
}

struct CurrencyRateRow: View {
    let key: String
    let value: Double
    
    var body: some View {
        
        if let countryCode = Provider.currencyToCountryCode[key] {
            ZStack {
                Color("WidgetBackground")
                    .cornerRadius(10)
                
                HStack{
                    Text("\(flag(for: countryCode)) \(key): ")
                        .font(.body)
                        .foregroundColor(Color(red: 131/255, green: 129/255, blue: 138/255))
                        .padding()
                    
                    Spacer()
                    
                    Text("\(String(format: "%.3f", value))")
                        .font(.body)
                        .foregroundColor(Color(red: 131/255, green: 129/255, blue: 138/255))
                        .padding()
                }
            }
        }
    }
    
    func flag(for countryCode: String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in countryCode.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }
}

//MARK: - Widget
struct CurrencyRatesWidget: Widget {
    let kind: String = "CurrencyRatesWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            CurrencyRatesWidgetEntryView(entry: entry)
                .containerBackground(.fill, for: .widget)
        }
        .contentMarginsDisabled()
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

