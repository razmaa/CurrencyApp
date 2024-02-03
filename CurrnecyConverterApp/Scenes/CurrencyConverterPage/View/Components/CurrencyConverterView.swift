//
//  CurrencyConverterView.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 03.02.24.
//

import SwiftUI

struct CurrencyConverterView: View {
    @StateObject private var viewModel = CurrencyConverterViewModel()
    @State private var amount = ""
    @State private var baseCurrency = "USD"
    @State private var targetCurrency = "EUR"

    var body: some View {
         VStack {
             Text("Currency Converter")
                 .font(.system(size: 22))
                 .foregroundColor(.white)
                 .padding()
             
             TextField("Amount", text: $amount)
                 .keyboardType(.numberPad)
                 .padding()
                 .background(Color.darkGray)
                 .foregroundColor(.white)
                 .cornerRadius(10)

             DatePicker("Select a Date", selection: $viewModel.selectedDate, displayedComponents: .date)
                 .padding()
                 .background(Color.darkGray)
                 .foregroundColor(.white)
                 .cornerRadius(10)

             HStack {
                 Button(action: { viewModel.convert(amount: amount, from: baseCurrency, to: targetCurrency) }) {
                     Text("Convert")
                         .font(.headline)
                         .foregroundColor(.white)
                         .padding()
                         .background(Color.primary)
                         .cornerRadius(10)
                 }
                 .disabled(amount.isEmpty)
                 
                 Button(action: { viewModel.convertHistorical(amount: amount, from: baseCurrency, to: targetCurrency, date: viewModel.selectedDate) }) {
                     Text("Convert on Selected Date")
                         .font(.headline)
                         .foregroundColor(.white)
                         .padding()
                         .background(Color.primary)
                         .cornerRadius(10)
                 }
                 .disabled(amount.isEmpty)
                 
             }
             .padding()
             
             HStack( spacing: 30) {
                 Picker("Base Currency", selection: $baseCurrency) {
                     ForEach(viewModel.currencies, id: \.self) { currency in
                         Text(currency).tag(currency)
                     }
                 }
                 .frame(minWidth: 100)
                 .padding()
                 .foregroundColor(Color.primary)
                 .background(Color.darkGray)
                 .cornerRadius(10)

                 Button(action: { swapCurrencies() }) {
                     Image(systemName: "rectangle.2.swap")
                         .foregroundColor(.primary)
                 }
                 .disabled(amount.isEmpty)

                 Picker("Target Currency", selection: $targetCurrency) {
                     ForEach(viewModel.currencies, id: \.self) { currency in
                         Text(currency).tag(currency)
                     }
                 }
                 .frame(minWidth: 100)
                 .padding()
                 .background(Color.darkGray)
                 .foregroundColor(.white)
                 .cornerRadius(10)
             }
             .padding()
             
             Spacer()
             
             VStack {
                 VStack {
                     Text("Today")
                         .font(.title3)
                         .foregroundColor(.primary)
                     
                     Text("\(viewModel.conversionResult) \(targetCurrency)")
                         .font(.title)
                         .foregroundColor(.primary)
                 }
                 
                 Divider()
                 
                 if (viewModel.historicalConversion != nil) {
                     VStack {
                         Text("Chosen date")
                             .font(.title3)
                             .foregroundColor(.primary)
                         
                         Text("\(viewModel.historicalConversion ?? "0.0") \(targetCurrency)")
                             .font(.title)
                             .foregroundColor(.primary)
                     }
                 }
             }

             Spacer()
         }
         .background(Color.background)
     }

    func swapCurrencies() {
        let temp = baseCurrency
        baseCurrency = targetCurrency
        targetCurrency = temp
        viewModel.convert(amount: amount, from: baseCurrency, to: targetCurrency)
        if viewModel.historicalConversion != nil {
            viewModel.convertHistorical(amount: amount, from: baseCurrency, to: targetCurrency, date: viewModel.selectedDate)
        }
    }
}
