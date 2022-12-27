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
        setupUI()
        normalRun()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(occuredFullData), name: Notification.Name.successDataLoading, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(occuredLoadingError), name: Notification.Name.errorLoadingData, object: nil)
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
        showLoadingIndicator()
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.dataManager.getReqiedData()
        }
      
    }
    
    @objc private func occuredFullData() {
        DispatchQueue.main.async {
            self.hideLoadingIndicator()
            self.goToHomeVC()
        }
    }
    
    @objc private func occuredLoadingError() {
        DispatchQueue.main.async {
            self.hideLoadingIndicator()
            let alert = UIAlertController(title: "Loading Failed", message: "Please check your Internet connection and try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .default) { _ in
                self.normalRun()
            })
            alert.addAction(UIAlertAction(title: "Exit", style: .cancel) { _ in
                exit(0)
            })
            self.present(alert, animated: true)
        }
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
