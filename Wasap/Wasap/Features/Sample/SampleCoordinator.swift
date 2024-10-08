//
//  SampleCoordinator.swift
//  Wasap
//
//  Created by chongin on 10/3/24.
//

import UIKit

public class SampleCoordinator: NavigationCoordinator {
    public var childCoordinators: [any Coordinator] = []
    public let navigationController: UINavigationController

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start() {
        let viewController = CameraViewController(cameraUseCase: DefaultCameraUseCase(repository: DefaultCameraRepository())) // SAMPLE입니다..!
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
