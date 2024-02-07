//
//  CryptoModel.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 07.02.24.
//

import Foundation

struct Crypto: Codable {
    let id: String
    let rank: String
    let symbol: String
    let name: String
    let supply: String
    let maxSupply: String?
    let marketCapUsd: String
    let volumeUsd24Hr: String
    let priceUsd: String
    let changePercent24Hr: String
    let vwap24Hr: String?
}

struct CryptoList: Codable {
    let data: [Crypto]
    let timestamp: Int64
}
