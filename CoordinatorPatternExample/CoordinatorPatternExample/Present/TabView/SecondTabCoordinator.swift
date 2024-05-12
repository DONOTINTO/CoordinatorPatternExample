//
//  SecondTabCoordinator.swift
//  CoordinatorPatternExample
//
//  Created by 이중엽 on 5/12/24.
//

import UIKit

protocol SecondTabCoordinatorProtocol: Coordinator {
    
    var secondTabViewController: SecondTabViewController { get set }
}

class SecondTabCoordinator: SecondTabCoordinatorProtocol {
    
    var secondTabViewController: SecondTabViewController
    
    var coordinatorType: CoordinatorType { .second }
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    func start() {
        
        navigationController.pushViewController(self.secondTabViewController, animated: true)
    }
    
    required init(_ navigationController: UINavigationController) {
        
        self.navigationController = navigationController
        self.secondTabViewController = SecondTabViewController()
    }
}

extension SecondTabCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
        // 자식 뷰를 삭제하는 델리게이트 (자식 -> 부모 접근 -> 부모에서 자식 삭제)
        self.childCoordinators = self.childCoordinators.filter { $0.coordinatorType != childCoordinator.coordinatorType }
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}
