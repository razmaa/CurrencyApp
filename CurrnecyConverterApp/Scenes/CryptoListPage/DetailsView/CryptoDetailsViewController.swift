//
//  CryptoDetailsViewController.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 11.02.24.
//

import UIKit

final class CryptoDetailsViewController: UIViewController {
    //MARK: - Properties
    var crypto: Crypto?
    var cryptoImage: UIImage?
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let detailsStackView = UIStackView()
    private let supplyLabel = UILabel()
    private let maxSupplyLabel = UILabel()
    private let marketCapLabel = UILabel()
    private let volumeLabel = UILabel()
    private let priceLabel = UILabel()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        populateData()
    }
    
    //MARK: - Methods
    private func setupUI() {
        view.backgroundColor = UIColor.background
        navigationItem.title = "Crypto Details"
        
        setupImageView()
        setupLabels()
        setupStackView()
        setupConstraints()
    }
    
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 75
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.primary.cgColor
        view.addSubview(imageView)
    }
    
    private func setupLabels() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = UIColor.primary
        view.addSubview(nameLabel)
        
        [supplyLabel, maxSupplyLabel, marketCapLabel, volumeLabel, priceLabel].forEach { label in
            label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            label.textColor = UIColor.white
            detailsStackView.addArrangedSubview(label)
        }
    }
    
    private func setupStackView() {
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        detailsStackView.axis = .vertical
        detailsStackView.distribution = .equalSpacing
        detailsStackView.spacing = 25
        detailsStackView.backgroundColor = .darkGray
        detailsStackView.layer.cornerRadius = 9
        detailsStackView.isLayoutMarginsRelativeArrangement = true
        detailsStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        view.addSubview(detailsStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 35),
            
            detailsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailsStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 50),
            detailsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func populateData() {
        guard let crypto = crypto else { return }
        imageView.image = cryptoImage
        nameLabel.text = crypto.name
        supplyLabel.text = "Supply: \(formatNumber(crypto.supply))"
        maxSupplyLabel.text = "Max Supply: \(crypto.maxSupply.map(formatNumber) ?? "N/A")"
        marketCapLabel.text = "Market Cap: \(formatNumber(crypto.marketCapUsd))"
        volumeLabel.text = "Volume (24hr): \(formatNumber(crypto.volumeUsd24Hr))"
        priceLabel.text = "Price: \(crypto.priceUsd)$"
    }
    
    private func formatNumber(_ string: String) -> String {
        if let number = Double(string) {
            return String(format: "%.3f", number)
        } else {
            return string
        }
    }
}


