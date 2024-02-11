//
//  CurrencyCell.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 30.01.24.
//

import UIKit

final class CurrencyCell: UITableViewCell {
    //MARK: - Properties
    let flagImageView: UIImageView = {
        let flagImageView = UIImageView()
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        flagImageView.layer.cornerRadius = 50
        flagImageView.clipsToBounds = true
        return flagImageView
    }()
    
    let currencyCodeLabel: UILabel = {
        let currencyCodeLabel = UILabel()
        currencyCodeLabel.textColor = .primary
        currencyCodeLabel.font = UIFont.systemFont(ofSize: 20)
        currencyCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        return currencyCodeLabel
    }()
    
    let currencyValueLabel: UILabel = {
        let currencyValueLabel = UILabel()
        currencyValueLabel.textColor = .white
        currencyValueLabel.font = UIFont.systemFont(ofSize: 20)
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
    //MARK: - Configure
    func configure(with currencyCode: String, currencyRate: Double, baseCurrency: String, onBaseCurrencyButtonTapped: @escaping () -> Void) {
        currencyCodeLabel.text = currencyCode
        currencyValueLabel.text = String(format: "%.3f", currencyRate)
        baseCurrencyButton.isSelected = (currencyCode == baseCurrency)
        self.onBaseCurrencyButtonTapped = onBaseCurrencyButtonTapped
    }
    
    //MARK: - Methods
    private func setupUI() {
        self.backgroundColor = .darkGray
        contentView.addSubview(flagImageView)
        contentView.addSubview(currencyCodeLabel)
        contentView.addSubview(currencyValueLabel)
        baseCurrencyButton.addTarget(self, action: #selector(baseCurrencyButtonTapped), for: .touchUpInside)
        contentView.addSubview(baseCurrencyButton)
        setUpCellConstraints()
    }
    
    private func setUpCellConstraints() {
        NSLayoutConstraint.activate([
            flagImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            flagImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            flagImageView.widthAnchor.constraint(equalToConstant: 80),
            flagImageView.heightAnchor.constraint(equalToConstant: 80),
            
            currencyCodeLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 20),
            currencyCodeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            currencyValueLabel.trailingAnchor.constraint(equalTo: baseCurrencyButton.leadingAnchor, constant: -20),
            currencyValueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            baseCurrencyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            baseCurrencyButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            baseCurrencyButton.widthAnchor.constraint(equalToConstant: 60),
            baseCurrencyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func baseCurrencyButtonTapped() {
        onBaseCurrencyButtonTapped?()
    }
}
