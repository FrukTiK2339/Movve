//
//  CommonPopUpViewController.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 24.01.2023.
//

import UIKit

class CommonPopUpViewController: UIViewController {
    
    private let errorButton = UIButton()
    var delegate: UpdateSectionDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(white: 1, alpha: 0.4)
        view.layer.cornerRadius = 24
        
        setupButton()
    }
    
    private func setupButton() {
        view.addSubview(errorButton)
        
        errorButton.setTitle("Try again", for: .normal)
        errorButton.addTarget(self, action: #selector(errorButtonTapped), for: .touchUpInside)
        
        errorButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            errorButton.widthAnchor.constraint(equalToConstant: 200),
            errorButton.heightAnchor.constraint(equalToConstant: 80),
            ])
    }
    
    @objc func errorButtonTapped() {
        delegate?.refreshSections()
        self.dismiss(animated: true)
    }
}
