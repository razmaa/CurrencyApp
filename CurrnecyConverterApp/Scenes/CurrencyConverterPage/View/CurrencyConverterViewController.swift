//
//  CurrencyConverterViewController.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 03.02.24.
//

import UIKit
import SwiftUI

class CurrencyConverterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let swiftUIView = CurrencyConverterView()
        let hostingController = UIHostingController(rootView: swiftUIView)
        self.addChild(hostingController)
        self.view.addSubview(hostingController.view)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])

        hostingController.didMove(toParent: self)
    }

}
