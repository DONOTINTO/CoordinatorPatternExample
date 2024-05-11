//
//  MainViewCoordinator.swift
//  CoordinatorPatternExample
//
//  Created by 이중엽 on 5/11/24.
//

import UIKit

protocol MainViewCoordinatorProtocol: Coordinator {
    
    func showMainViewController()
}

class MainViewCoordinator: MainViewCoordinatorProtocol {
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var coordinatorType: CoordinatorType { .main }
    
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()
    
    func start() {
        
        print("Main View Coordinator Start")
        showMainViewController()
    }
    
    func showMainViewController() {
        
        print("Main View Coordinator showMainViewController")
        let mainViewController = MainViewController()
        
        mainViewController.buttonClickedClosure = { [weak self] in
            
            guard let self else { return }
            self.finish()
        }
        
        navigationController.setViewControllers([mainViewController], animated: false)
    }
    
    required init(_ navigationController: UINavigationController) {
        print("Main View Coordinator Init")
        self.navigationController = navigationController
    }
    
    deinit {
        print("mainViewDeinit")
    }
    
}
