//
//  CurrencyChartViewController.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 01.02.24.
//

import UIKit
import DGCharts

class CurrencyChartViewController: UIViewController {
    //MARK: - Properties
    var viewModel = CurrencyChartViewModel()
    var lineChartView: LineChartView!
    var segmentedControl: UISegmentedControl!
    let targetCurrencyPicker = UIPickerView()
    let baseCurrencyPicker = UIPickerView()
    let toolBar = UIToolbar()
    
    let baseCurrencyField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .primary
        textField.text = "EUR"
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let targetCurrencyField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .primary
        textField.text = "USD"
        textField.textAlignment = .center
       //textField.isUserInteractionEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let currencyLabel: UILabel = {
        let currencyLabel = UILabel()
        currencyLabel.textColor = .white
        currencyLabel.font = UIFont.systemFont(ofSize: 22)
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        return currencyLabel
    }()
    
    let swapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up.arrow.down.square.fill"), for: .normal)
        button.tintColor = .primary
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        fetchDataAndUpdateChart(for: "1W")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let period = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) ?? "1W"
        fetchDataAndUpdateChart(for: period)
    }

    
    //MARK: - Methods
    private func setupUI() {
        view.backgroundColor = .background
        setupLineChartView()
        setupSegmentedControlView()
        view.addSubview(currencyLabel)
        setupTextFields()
        setupToolBar()
        setupSwapButton()
        setupConstraints()
    }
    
    private func setupTextFields() {
        view.addSubview(targetCurrencyField)
        view.addSubview(baseCurrencyField)
        baseCurrencyField.inputView = baseCurrencyPicker
        targetCurrencyField.inputView = targetCurrencyPicker

        baseCurrencyPicker.delegate = self
        baseCurrencyPicker.dataSource = self
        targetCurrencyPicker.delegate = self
        targetCurrencyPicker.dataSource = self
        
        targetCurrencyField.addTarget(self, action: #selector(targetCurrencyFieldTapped), for: .touchUpInside)
        baseCurrencyField.addTarget(self, action: #selector(baseCurrencyFieldTapped), for: .touchUpInside)
    }
    
    private func setupLineChartView() {
        lineChartView = LineChartView()
        lineChartView.legend.enabled = false
        lineChartView.translatesAutoresizingMaskIntoConstraints = false

        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        
        lineChartView.xAxis.drawLabelsEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        
        lineChartView.drawBordersEnabled = false
        view.addSubview(lineChartView)
    }
    
    private func setupSegmentedControlView() {
        segmentedControl = UISegmentedControl(items: ["1 WEEK", "1 MONTH", "1 YEAR"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .darkGray
        segmentedControl.selectedSegmentTintColor = .primary
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        segmentedControl.backgroundColor = UIColor.lightGray
        view.addSubview(segmentedControl)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            currencyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            currencyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            lineChartView.topAnchor.constraint(equalTo: currencyLabel.bottomAnchor, constant: 35),
            lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            lineChartView.heightAnchor.constraint(equalToConstant: 300),

            segmentedControl.topAnchor.constraint(equalTo: lineChartView.bottomAnchor, constant: 35),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),

            baseCurrencyField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 60),
            baseCurrencyField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            baseCurrencyField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            baseCurrencyField.heightAnchor.constraint(equalToConstant: 50),
            
            swapButton.topAnchor.constraint(equalTo: baseCurrencyField.bottomAnchor, constant: 30),
            swapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            swapButton.widthAnchor.constraint(equalToConstant: 100),
            swapButton.heightAnchor.constraint(equalToConstant: 30),
            
            targetCurrencyField.topAnchor.constraint(equalTo: swapButton.bottomAnchor, constant: 30),
            targetCurrencyField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            targetCurrencyField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            targetCurrencyField.heightAnchor.constraint(equalToConstant: 50),
        ])

    }
    
    private func setupToolBar() {
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))
        toolBar.setItems([doneButton], animated: false)
        targetCurrencyField.inputAccessoryView = toolBar
        baseCurrencyField.inputAccessoryView = toolBar
    }
    
    private func setupSwapButton() {
        swapButton.addTarget(self, action: #selector(swapButtonTapped), for: .touchUpInside)
        view.addSubview(swapButton)
    }
    
    private func fetchDataAndUpdateChart(for period: String) {
        let baseCurrency = baseCurrencyField.text ?? "EUR"
        let targetCurrency = targetCurrencyField.text ?? "USD"
        currencyLabel.text = "\(baseCurrency) per 1 \(targetCurrency)"
        viewModel.fetchDataAndUpdateChart(for: period, baseCurrency: baseCurrency, targetCurrency: targetCurrency) { [weak self] chartData in
            DispatchQueue.main.async {
                self?.lineChartView.data = chartData
            }
        }
    }
    
    @objc func targetCurrencyFieldTapped() {
        targetCurrencyPicker.isHidden = false
        fetchDataAndUpdateChart(for: segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) ?? "1W")
    }
    
    @objc func baseCurrencyFieldTapped() {
        baseCurrencyPicker.isHidden = false
        fetchDataAndUpdateChart(for: segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) ?? "1W")
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let period = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "1W"
        fetchDataAndUpdateChart(for: period)
    }
    
    @objc func donePicker() {
        targetCurrencyField.resignFirstResponder()
        baseCurrencyField.resignFirstResponder()
    }
    
    @objc func swapButtonTapped() {
        let temp = baseCurrencyField.text
        baseCurrencyField.text = targetCurrencyField.text
        targetCurrencyField.text = temp
        fetchDataAndUpdateChart(for: segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) ?? "1W")
    }

}

//MARK: - Extensions(PickerView)
extension CurrencyChartViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.targetCurrencies.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.targetCurrencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == targetCurrencyPicker {
            let selectedCurrency = viewModel.targetCurrencies[row]
            targetCurrencyField.text = selectedCurrency
        } else if pickerView == baseCurrencyPicker {
            let selectedCurrency = viewModel.targetCurrencies[row]
            baseCurrencyField.text = selectedCurrency
        }
        fetchDataAndUpdateChart(for: segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) ?? "1W")
    }
}
