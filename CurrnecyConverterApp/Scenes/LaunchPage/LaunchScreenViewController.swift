//
//  LaunchScreenViewController.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 07.02.24.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "AppIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),  // Adjust as needed
            logoImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.logoImageView.transform = CGAffineTransform(rotationAngle: .pi * 2)
        })
    }

}
