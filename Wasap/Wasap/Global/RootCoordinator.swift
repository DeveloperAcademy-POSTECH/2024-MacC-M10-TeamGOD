//
//  RootCoordinator.swift
//  Wasap
//
//  Created by chongin on 10/3/24.
//

import UIKit

public class RootCoordinator: Coordinator {
    public var childCoordinators: [Coordinator] = []
    let window: UIWindow?
    let appDIContainer: AppDIContainer

    init(window: UIWindow?, appDIContainer: AppDIContainer) {
        self.window = window
        self.appDIContainer = appDIContainer
    }

    public enum Flow {

    }

    public func start() {
        let sampleCoordinator = SampleCoordinator(navigationController: UINavigationController())
        start(childCoordinator: sampleCoordinator)
        window?.rootViewController = sampleCoordinator.navigationController
        window?.makeKeyAndVisible()
    }
}

public class SampleCoordinator: NavigationCoordinator {
    public var childCoordinators: [any Coordinator] = []
    public let navigationController: UINavigationController

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start() {
        let viewController = ViewController() // SAMPLE입니다..!
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
