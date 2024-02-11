//
//  CryptoListViewModel.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 07.02.24.
//

import NetworkManager
import UIKit

class CryptoListViewModel {
    //MARK: - Properties
    var cryptos: [Crypto] = []
    private var images: [String: UIImage] = [:]
    private var cryptoNetworkManager = GenericNetworkManager(baseURL: "https://api.coincap.io")
    private var imageNetworkManager = GenericNetworkManager(baseURL: "https://coinicons-api.vercel.app/api/icon/")
    
    //MARK: - Methods
    func fetchCryptos(completion: @escaping () -> Void) {
        cryptoNetworkManager.fetchData(endpoint: "/v2/assets") { (result: Result<CryptoList, Error>) in
            switch result {
            case .success(let cryptoList):
                self.cryptos = cryptoList.data
                self.fetchImages {
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func fetchImages(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        for crypto in cryptos {
            group.enter()
            imageNetworkManager.fetchImage(endpoint: String(crypto.symbol).lowercased()) { result in
                switch result {
                case .success(let image):
                    self.images[crypto.symbol] = image
                case .failure(let error):
                    print("Error fetching logo: \(error)")
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion()
        }
    }
    
    func numberOfRows() -> Int {
        return cryptos.count
    }
    
    func crypto(at index: Int) -> Crypto {
        return cryptos[index]
    }
    
    func image(for crypto: Crypto) -> UIImage? {
        return images[crypto.symbol]
    }
}
