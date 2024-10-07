//
//  Coordinator.swift
//  Wasap
//
//  Created by chongin on 9/29/24.
//

import UIKit

public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
    func start(childCoordinator: Coordinator)
    func `switch`(childCoordinator: Coordinator)
    func didFinish(childCoordinator: Coordinator)
    func removeChildCoordinators()
}

extension Coordinator {
    public func start(childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
        childCoordinator.start()
    }

    public func `switch`(childCoordinator: Coordinator) {
        if let lastCoordinator = self.childCoordinators.last {
            didFinish(childCoordinator: lastCoordinator)
        }
        start(childCoordinator: childCoordinator)
    }

    public func didFinish(childCoordinator: Coordinator) {
        self.childCoordinators.filter { $0 === childCoordinator }
            .forEach { $0.removeChildCoordinators() }
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }

    public func removeChildCoordinators() {
        childCoordinators.forEach { $0.removeChildCoordinators() }
        childCoordinators.removeAll()
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
