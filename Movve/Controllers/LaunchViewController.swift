//
//  LaunchViewController.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import UIKit

class LaunchViewController: UIViewController {
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(occuredFullData), name: Notification.Name.successDataLoading, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        normalRun()
    }
    
    private func normalRun() {
        
        DataManager.shared.getReqiedData()
    }
    
    @objc private func occuredFullData() {
        goToHomeVC()
    }
    
    private func goToHomeVC() {
        let vc = HomeViewController()
        navigationController?.setViewControllers([vc], animated:true)
    }
    
    
}
