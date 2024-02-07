//
//  CurrencyConverterView.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 03.02.24.
//

import SwiftUI

struct CurrencyConverterView: View {
    //MARK: - Properties
    @StateObject private var viewModel = CurrencyConverterViewModel()
    @State private var amount = ""
    @State private var baseCurrency = "USD"
    @State private var targetCurrency = "EUR"
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColorsSwiftUI.background.ignoresSafeArea(.all)
                mainView
            }
        }
    }
    
    //MARK: - Components
    private var mainView: some View {
        VStack() {
            titleView
            amountField
            datePicker
            conversionButtons
            currencyPickers
            Spacer()
            conversionResults
            Spacer()
        }
        .padding(.vertical, 5)
    }
    
    private var titleView: some View {
        Text("Currency Converter")
            .font(.system(size: 22))
            .foregroundColor(.white)
            .padding()
    }
    
    private var amountField: some View {
        TextField("Amount", text: $amount)
            .keyboardType(.numberPad)
            .padding()
            .background(Color.darkGray)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
    
    private var datePicker: some View {
        DatePicker("Select a Date", selection: $viewModel.selectedDate, displayedComponents: .date)
            .padding()
            .background(Color.darkGray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .onChange(of: viewModel.selectedDate) { oldValue, newValue in
                if !amount.isEmpty {
                    viewModel.convert(amount: amount, from: baseCurrency, to: targetCurrency)
                    viewModel.convertHistorical(amount: amount, from: baseCurrency, to: targetCurrency, date: newValue)
                }
            }
    }
    
    private var conversionButtons: some View {
        HStack {
            convertButton(action: {
                viewModel.convert(amount: amount, from: baseCurrency, to: targetCurrency)
                viewModel.convertHistorical(amount: amount, from: baseCurrency, to: targetCurrency, date: viewModel.selectedDate)
            }, title: "Convert")
        }
        .padding()
    }
    
    private func convertButton(action: @escaping () -> Void, title: String) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.primary)
                .cornerRadius(10)
        }
        .disabled(amount.isEmpty)
    }
    
    private var currencyPickers: some View {
        HStack(spacing: 30) {
            currencyPicker(selection: $baseCurrency)
            swapButton
            currencyPicker(selection: $targetCurrency)
        }
        .padding()
    }
    
    private var swapButton: some View {
        Button(action: { swapCurrencies() }) {
            Image(systemName: "rectangle.2.swap")
                .foregroundColor(.primary)
        }
        .disabled(amount.isEmpty)
    }
    
    private var conversionResults: some View {
        VStack {
            conversionResult(title: "Today", result: viewModel.conversionResult)
            Divider()
            conversionResult(title: "Chosen date", result: viewModel.historicalConversion ?? "0.0")
        }
    }
    
    //MARK: - Methods
    private func currencyPicker(selection: Binding<String>) -> some View {
        Picker("Currency", selection: selection) {
            ForEach(viewModel.currencies, id: \.self) { currency in
                Text(currency).tag(currency)
            }
        }
        .frame(minWidth: 100)
        .padding()
        .background(Color.darkGray)
        .foregroundColor(.white)
        .cornerRadius(10)
        .onChange(of: baseCurrency) {
            if !amount.isEmpty {
                viewModel.convert(amount: amount, from: baseCurrency, to: targetCurrency)
                viewModel.convertHistorical(amount: amount, from: baseCurrency, to: targetCurrency, date: viewModel.selectedDate)
            }
        }
        .onChange(of: targetCurrency) {
            if !amount.isEmpty {
                viewModel.convert(amount: amount, from: baseCurrency, to: targetCurrency)
                viewModel.convertHistorical(amount: amount, from: baseCurrency, to: targetCurrency, date: viewModel.selectedDate)
            }
        }
    }
    
    private func conversionResult(title: String, result: String) -> some View {
        VStack {
            Text(title)
                .font(.title3)
                .foregroundColor(.primary)
            Text("\(result) \(targetCurrency)")
                .font(.title)
                .foregroundColor(.primary)
        }
    }
    
    private func swapCurrencies() {
        let temp = baseCurrency
        baseCurrency = targetCurrency
        targetCurrency = temp
        viewModel.convert(amount: amount, from: baseCurrency, to: targetCurrency)
        if viewModel.historicalConversion != nil {
            viewModel.convertHistorical(amount: amount, from: baseCurrency, to: targetCurrency, date: viewModel.selectedDate)
        }
    }
}

