//
//  CurrencyModel.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 22.01.24.
//

import Foundation

struct CurrencyResponse: Decodable {
    let rates: [String: Double]
    let base: String
    let date: String
}

struct APIError: Decodable {
    let error: String
}
