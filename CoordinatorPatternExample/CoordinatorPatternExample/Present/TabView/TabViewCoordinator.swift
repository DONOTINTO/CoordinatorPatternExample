//
//  TabViewCoordinator.swift
//  CoordinatorPatternExample
//
//  Created by 이중엽 on 5/11/24.
//

import UIKit

protocol TabBarCoordinatorProtocol: Coordinator {
    
    var tabBarController: UITabBarController { get set }
}

class TabBarCoordinator: TabBarCoordinatorProtocol {
    
    var tabBarController: UITabBarController
    
    var coordinatorType: CoordinatorType
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    func start() {
        
        // 1. 탭바 아이템 리스트 생성
        let pages: [TabBarItemType] = TabBarItemType.allCases
        // 2. 탭바 아이템 생성
        let tabBarItems: [UITabBarItem] = pages.map { self.createTabBarItem(of: $0) }
        // 3. 탭바별 navigation controller 생성
        let controllers: [UINavigationController] = tabBarItems.map {
            self.createTabNavigationController(tabBarItem: $0)
        }
        // 4. 탭바별로 코디네이터 생성하기
        let _ = controllers.map{ self.startTabCoordinator(tabNavigationController: $0) }
        // 5. 탭바 스타일 지정 및 VC 연결
        self.configureTabBarController(tabNavigationControllers: controllers)
        // 6. 탭바 화면에 붙이기
        self.addTabBarController()
    }
    
    required init(_ navigationController: UINavigationController) {
        
        self.navigationController = navigationController
        self.coordinatorType = CoordinatorType.tab
        self.tabBarController = UITabBarController()
    }
    
    // MARK: - TabBarController 설정 메소드
    
    private func configureTabBarController(tabNavigationControllers: [UIViewController]){
        
        // TabBar의 VC 지정
        self.tabBarController.setViewControllers(tabNavigationControllers, animated: false)
        // home의 index로 TabBar Index 세팅
        self.tabBarController.selectedIndex = TabBarItemType.first.toInt()
        // TabBar 스타일 지정
        self.tabBarController.view.backgroundColor = .systemBackground
        self.tabBarController.tabBar.backgroundColor = .systemBackground
        self.tabBarController.tabBar.tintColor = UIColor.black
    }
    
    private func addTabBarController(){
        // 화면에 추가
        self.navigationController.pushViewController(self.tabBarController, animated: true)
    }
    
    private func createTabBarItem(of page: TabBarItemType) -> UITabBarItem {
        
        return UITabBarItem(
            title: page.toName(),
            image: UIImage(systemName: page.toIconName()),
            tag: page.toInt()
        )
    }
    
    /// 탭바 페이지대로 탭바 생성
    private func createTabNavigationController(tabBarItem: UITabBarItem) -> UINavigationController{
        
        let tabNavigationController = UINavigationController()
        
        // 상단에서 NavigationBar 숨김 해제
        tabNavigationController.setNavigationBarHidden(false, animated: false)
        // 상단 NavigationBar에 title 설정
        tabNavigationController.navigationBar.topItem?.title = TabBarItemType(index: tabBarItem.tag)?.toName()
        // tabBarItem 설정을 통해 NavigationController와 tabBarItem를 연결
        tabNavigationController.tabBarItem = tabBarItem
        
        return tabNavigationController
    }
    
    private func startTabCoordinator(tabNavigationController: UINavigationController) {
        
        // tag 번호로 TabBarPage로 변경
        let tabBarItemTag: Int = tabNavigationController.tabBarItem.tag
        guard let tabBarItemType: TabBarItemType = TabBarItemType(index: tabBarItemTag) else { return }
        
        // 코디네이터 생성 및 실행
        switch tabBarItemType {
        case .first:
            let firstCoordinator = FirstTabCoordinator(tabNavigationController)
            firstCoordinator.finishDelegate = self
            self.childCoordinators.append(firstCoordinator)
            firstCoordinator.start()
        case .second:
            let secondCoordinator = SecondTabCoordinator(tabNavigationController)
            secondCoordinator.finishDelegate = self
            self.childCoordinators.append(secondCoordinator)
            secondCoordinator.start()
        }
    }
}

extension TabBarCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.navigationController.viewControllers.removeAll()
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}


enum TabBarItemType: String, CaseIterable {
    case first, second
    
    // Int형에 맞춰 초기화
    init?(index: Int) {
        switch index {
        case 0: self = .first
        case 1: self = .second
        default: return nil
        }
    }
    
    /// TabBarPage 형을 매칭되는 Int형으로 반환
    func toInt() -> Int {
        switch self {
        case .first: return 0
        case .second: return 1
        }
    }
    
    /// TabBarPage 형을 매칭되는 이름으로 변환
    func toName() -> String {
        switch self {
        case .first: return "first"
        case .second: return "second"
        }
    }
    
    /// TabBarPage 형을 매칭되는 아이콘명으로 변환
    func toIconName() -> String {
        switch self {
        case .first: return "house"
        case .second: return "star"
        }
    }
}
