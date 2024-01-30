//
//  CurrencyCell.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 30.01.24.
//

import UIKit

class CurrencyCell: UITableViewCell {
    //MARK: - Properties
    
    let flagImageView: UIImageView = {
        let flagImageView = UIImageView()
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        return flagImageView
    }()
    
    let currencyCodeLabel: UILabel = {
        let currencyCodeLabel = UILabel()
        currencyCodeLabel.textColor = .primary
        currencyCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        return currencyCodeLabel
    }()
    
    let currencyNameLabel: UILabel = {
        let currencyNameLabel = UILabel()
        currencyNameLabel.textColor = .gray
        currencyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return currencyNameLabel
    }()
    
    let currencyValueLabel: UILabel = {
        let currencyValueLabel = UILabel()
        currencyValueLabel.textColor = .white
        currencyValueLabel.translatesAutoresizingMaskIntoConstraints = false
        return currencyValueLabel
    }()
    
    let baseCurrencyButton: UIButton = {
        let baseCurrencyButton = UIButton(type: .system)
        baseCurrencyButton.setImage(UIImage(systemName: "australiandollarsign.arrow.circlepath"), for: .normal)
        baseCurrencyButton.setImage(UIImage(systemName: "australiandollarsign.arrow.circlepath.fill"), for: .selected)
        baseCurrencyButton.setTitleColor(.primary, for: .normal)
        baseCurrencyButton.translatesAutoresizingMaskIntoConstraints = false
        return baseCurrencyButton
    }()
    
    var onBaseCurrencyButtonTapped: (() -> Void)?
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    private func setupUI() {
        contentView.addSubview(flagImageView)
        
        contentView.addSubview(currencyCodeLabel)
        
        contentView.addSubview(currencyNameLabel)
        
        contentView.addSubview(currencyValueLabel)
        
        baseCurrencyButton.addTarget(self, action: #selector(baseCurrencyButtonTapped), for: .touchUpInside)
        contentView.addSubview(baseCurrencyButton)
        
        setUpCellConstraints()
        
        contentView.backgroundColor = .darkGray
        
    }
    
    private func setUpCellConstraints() {
        NSLayoutConstraint.activate([
            flagImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            flagImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            flagImageView.widthAnchor.constraint(equalToConstant: 30),
            flagImageView.heightAnchor.constraint(equalToConstant: 30),
            
            currencyCodeLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 10),
            currencyCodeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            currencyNameLabel.leadingAnchor.constraint(equalTo: currencyCodeLabel.leadingAnchor),
            currencyNameLabel.topAnchor.constraint(equalTo: currencyCodeLabel.bottomAnchor, constant: 10),
            
            currencyValueLabel.trailingAnchor.constraint(equalTo: baseCurrencyButton.leadingAnchor, constant: -10),
            currencyValueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            baseCurrencyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            baseCurrencyButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            baseCurrencyButton.widthAnchor.constraint(equalToConstant: 30),
            baseCurrencyButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func baseCurrencyButtonTapped() {
        onBaseCurrencyButtonTapped?()
    }
}
