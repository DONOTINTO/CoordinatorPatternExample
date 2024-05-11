//
//  Coordinator.swift
//  CoordinatorPatternExample
//
//  Created by 이중엽 on 5/11/24.
//

import UIKit

protocol CoordinatorFinishDelegate: AnyObject {
    
    func coordinatorDidFinish(childCoordinator: Coordinator)
}


protocol Coordinator: AnyObject {
    
    /// 코디네이터 타입 지정
    var coordinatorType: CoordinatorType { get }
    
    /// 각 코디네이터는 할당된 네비게이션 컨트롤러가 존재
    var navigationController: UINavigationController { get set }
    
    /// 모든 자식 코디네이터를 추적하는 배열로, 대부분 자식 코디네이터는 하나만 갖습니다.
    var childCoordinators: [Coordinator] { get set }
    
    /// 자식 코디네이터가 언제 종료되는지 알려주는 델리게이트 프로토콜
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    /// 코디네이터 로직이 실행되는 부분
    func start()
    
    /// 코디네이터 로직이 끝나는 부분 + 모든 자식 코디네이터를 삭제 + 부모 코디네이터에게 해당 코디네이터가 할당 해제됨을 알려줌
    func finish()
    
    init(_ navigationController: UINavigationController)
}

extension Coordinator {
    
    func finish() {
        print("finish")
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}


enum CoordinatorType {
    
    case app
    case main
}
