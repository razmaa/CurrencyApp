//
//  ExchangeRateModel.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 01.02.24.
//

import Foundation

struct ExchangeRateTimeSeries: Decodable {
    let base: String
    let start_date: String
    let end_date: String
    let rates: [String: [String: Double]]
}
