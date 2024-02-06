//
//  AppIntent.swift
//  CurrencyRatesWidget
//
//  Created by nika razmadze on 05.02.24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Currency Rates Widget Configuration"
    static var description = IntentDescription("Configure your Currency Rates widget.")

    // An example configurable parameter.
    @Parameter(title: "Base Currency", default: "EUR")
    dynamic var baseCurrency: String?
    
    var currencyOptions: [String] {
        return UserDefaults.standard.stringArray(forKey: "CurrencyData") ?? []
    }
}


