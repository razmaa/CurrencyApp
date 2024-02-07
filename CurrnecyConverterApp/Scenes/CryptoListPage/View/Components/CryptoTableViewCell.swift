//
//  CryptoTableViewCell.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 07.02.24.
//

import UIKit

class CryptoTableViewCell: UITableViewCell {
    //MARK: - Properties
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.primary
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    let priceBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        return view
    }()
    
    let changePercentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    
    let symbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()

    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        backgroundColor = UIColor.darkGray
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    func configure(with crypto: Crypto, image: UIImage?) {
        nameLabel.text = crypto.name
        if let price = Double(crypto.priceUsd) {
            priceLabel.text = String(format: "$%.2f", price)
        } else {
            priceLabel.text = "N/A"
        }
        if let changePercent24Hr = Double(crypto.changePercent24Hr) {
            changePercentLabel.text = String(format: "%.2f%%", changePercent24Hr)
            symbolLabel.text = changePercent24Hr < 0 ? "↓" : "↑"
            let color = changePercent24Hr < 0 ? UIColor.red : UIColor.systemGreen
            priceBackgroundView.backgroundColor = color
            changePercentLabel.textColor = color
            symbolLabel.textColor = color
        } else {
            priceBackgroundView.backgroundColor = UIColor.gray
            changePercentLabel.textColor = UIColor.gray
            symbolLabel.textColor = UIColor.gray
        }
        logoImageView.image = image
    }

    //MARK: - Methods
    private func setupViews() {
        addSubview(priceBackgroundView)
        addSubview(logoImageView)
        addSubview(nameLabel)
        addSubview(priceLabel)
        addSubview(changePercentLabel)
        addSubview(symbolLabel)

        bringSubviewToFront(logoImageView)
        bringSubviewToFront(nameLabel)
        bringSubviewToFront(priceLabel)
        bringSubviewToFront(changePercentLabel)
        bringSubviewToFront(symbolLabel)
        
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 55),
            logoImageView.heightAnchor.constraint(equalToConstant: 55),

            nameLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            
            priceBackgroundView.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -8),
            priceBackgroundView.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 8),
            priceBackgroundView.topAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -4),
            priceBackgroundView.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            priceBackgroundView.widthAnchor.constraint(equalToConstant: 100),
            
            changePercentLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -14),
            changePercentLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            symbolLabel.trailingAnchor.constraint(equalTo: changePercentLabel.leadingAnchor, constant: -4),
            symbolLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
