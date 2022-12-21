//
//  LaunchViewController.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import UIKit

class LaunchViewController: UIViewController {
    
    private let iconLabel = UILabel()
    private let loadingIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        setupIconLabel()
        showLoadingIndicator()
        setupUI()
        normalRun()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(occuredFullData), name: Notification.Name.successDataLoading, object: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = .mainAppColor
        view.addSubview(iconLabel)
        view.addSubview(loadingIndicator)
        
       
        
        
        loadingIndicator.style = .large
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            iconLabel.bottomAnchor.constraint(equalTo: loadingIndicator.topAnchor, constant: -.launchIconPadding),
            iconLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        
        

    }
    
    private func setupIconLabel() {
        view.addSubview(iconLabel)
        let string = NSMutableAttributedString(string: .appIconTittleFull)
        string.setColorForText(.appIconTittleFirst, with: .prettyWhite)
        string.setColorForText(.appIconTittleSecond, with: .redIconColor)
        iconLabel.font = .launcgIconFont
        iconLabel.attributedText = string
    }
    
    private func normalRun() {
        DispatchQueue.global(qos: .background).async {
            DataManager.shared.getReqiedData()
        }
      
    }
    
    @objc private func occuredFullData() {
        hideLoadingIndicator()
        goToHomeVC()
    }
    
    private func showLoadingIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
            self.loadingIndicator.isHidden = false
        }
        
    }
    
    private func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
            
        }
    }
    
    private func goToHomeVC() {
        let vc = HomeViewController()
        navigationController?.setViewControllers([vc], animated:true)
    }
    
    
}
