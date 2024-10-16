//
//  Coordinator.swift
//  Wasap
//
//  Created by chongin on 9/29/24.
//

import UIKit

public protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
    func start(childCoordinator: Coordinator)
    func `switch`(childCoordinator: Coordinator)
    func finishChildCoordinator(childCoordinator: Coordinator)
    func removeChildCoordinators()
    func finishCurrentCoordinator()
}

extension Coordinator {
    /// 현재 Coordinator에서 새로운 Coordinator를 시작합니다.
    /// 새로운 Coordinator의 부모는 현재 Coordinator가 됩니다.
    /// 이 함수로 들어온 Coordinator를 바로 start()합니다.
    public func start(childCoordinator: Coordinator) {
        childCoordinator.parentCoordinator = self
        self.childCoordinators.append(childCoordinator)
        childCoordinator.start()
    }

    public func `switch`(childCoordinator: Coordinator) {
        childCoordinator.parentCoordinator = self
        if let lastCoordinator = self.childCoordinators.last {
            finishChildCoordinator(childCoordinator: lastCoordinator)
        }
        start(childCoordinator: childCoordinator)
    }

    /// 현재 Coordinator의 자식 중 인자로 들어온 Coordinator를 종료합니다.
    /// 종료되는 Coordinator들은 parent 정보도 잃게 됩니다.
    /// 재귀적으로 종료합니다.
    public func finishChildCoordinator(childCoordinator: Coordinator) {
        self.childCoordinators.filter { $0 === childCoordinator }
            .forEach {
                $0.parentCoordinator = nil
                $0.removeChildCoordinators()
            }
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }

    /// 현재 Coordinator가 갖고 있는 모든 자식 Coordinator들을 재귀적으로 종료합니다.
    /// 종료되는 Coordinator들을 parent 정보도 잃게 됩니다.
    public func removeChildCoordinators() {
        childCoordinators.forEach {
            $0.parentCoordinator = nil
            $0.removeChildCoordinators()
        }
        childCoordinators.removeAll()
    }

    /// 현재 Coordinator를 종료합니다.
    /// 화면 전환 관련 로직은 따로 실행해주세요.
    public func finishCurrentCoordinator() {
        removeChildCoordinators()
        if let parentCoordinator {
            parentCoordinator.finishChildCoordinator(childCoordinator: self)
        }
    }
}

public protocol TabCoordinator: Coordinator {
    var tabBarController: UITabBarController { get }
}

public protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get }
}

// MARK: - CoordinatorController ( 추가 )
public protocol WifiConnectCoordinatorController: AnyObject {
    func performTransition(to flow: WifiConnectCoordinator.Flow)
}

public protocol CameraCoordinatorController: AnyObject {
    func performTransition(to flow: CameraCoordinator.Flow)
}

public protocol GoToSettingCoordinatorController: AnyObject {
    func performTransition(to flow: GoToSettingCoordinator.Flow)
}
