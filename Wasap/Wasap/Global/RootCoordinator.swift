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
