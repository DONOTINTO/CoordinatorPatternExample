//
//  AppCoordinator.swift
//  CoordinatorPatternExample
//
//  Created by 이중엽 on 5/11/24.
//

import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    
    func showMainFlow()
    func showTabFlow()
}

class AppCoordinator: AppCoordinatorProtocol {
    
    var finishDelegate: CoordinatorFinishDelegate? = nil
    
    var coordinatorType: CoordinatorType = .app
    
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()
    
    func start() {
        
        print("App Coordinator Start")
        
        let random = Int.random(in: 1...2)
        
        if random == 1 {
            showMainFlow()
        } else {
            showTabFlow()
        }
    }
    
    required init(_ navigationController: UINavigationController) {
        print("App Coordinator Init")
        self.navigationController = navigationController
        
    }
    
    // VC가 연결되면 ChildCoordinators에 추가
    func showMainFlow() {
        print("App Coordinator Show Main Flow")
        let mainViewCoordinator = MainViewCoordinator(navigationController)
        mainViewCoordinator.finishDelegate = self
        mainViewCoordinator.start()
        
        childCoordinators.append(mainViewCoordinator)
    }
    
    func showTabFlow() {
        print("App Coordinator Show Tab Flow")
        let tabBarCoordinator = TabBarCoordinator(navigationController)
        tabBarCoordinator.finishDelegate = self
        tabBarCoordinator.start()
        
        childCoordinators.append(tabBarCoordinator)
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print("App Coordinator coordinatorDidFinish")
        
        childCoordinators = childCoordinators.filter {
            
            // 내가 가지고 있는 자식 코디네이터 중 종료된 코디네이터(파라미터로 들어온 코디네이터)를 제외
            $0.coordinatorType != childCoordinator.coordinatorType
        }
        
        switch childCoordinator.coordinatorType {
        case .main:
            navigationController.viewControllers.removeAll()
            
            showTabFlow()
        case .tab:
            print("Tab View Coordinator 종료")
        default:
            return
        }
    }
}
