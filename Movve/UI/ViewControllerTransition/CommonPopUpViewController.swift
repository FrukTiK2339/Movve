//
//  CommonPopUpViewController.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 24.01.2023.
//

import UIKit

class CommonPopUpViewController: UIViewController {
    
    private let discripLabel = UILabel()
    private let panelButton = UIButton()
    var delegate: UpdateSectionDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(white: 1, alpha: 0.4)
        view.layer.cornerRadius = 24
        
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        view.addSubview(panelButton)
        view.addSubview(discripLabel)
        
        panelButton.setTitle("Try again", for: .normal)
        panelButton.addTarget(self, action: #selector(errorButtonTapped), for: .touchUpInside)
        panelButton.backgroundColor = .redIconColor
        panelButton.layer.cornerRadius = .cornerRadius
        panelButton.translatesAutoresizingMaskIntoConstraints = false
        
        discripLabel.textAlignment = .center
        discripLabel.numberOfLines = 0
        discripLabel.font = .cellTitleFont
        discripLabel.text = "This content may not be available in your country. \n Try turning on the VPN."
        discripLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            discripLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .iconPadding),
            discripLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: .iconPadding),
            discripLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -.iconPadding),
            discripLabel.bottomAnchor.constraint(equalTo: panelButton.topAnchor, constant: -.iconPadding),
            
            panelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            panelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.iconPadding),
            panelButton.widthAnchor.constraint(equalToConstant: .watchButtonWidth),
            panelButton.heightAnchor.constraint(equalToConstant: .watchButtonHeight),
            ])
    }
    
    @objc func errorButtonTapped() {
        delegate?.refreshSections() { [self] success in
            if success {
                self.delegate?.handleSuccessLoadingData()
            } else {
                self.delegate?.handleLoadingDataError()
            }
        }
        self.dismiss(animated: true)
    }
}
