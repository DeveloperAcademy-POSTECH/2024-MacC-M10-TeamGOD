//
//  CameraCoordinator.swift
//  Wasap
//
//  Created by chongin on 10/10/24.
//

import UIKit

public class CameraCoordinator: NavigationCoordinator {
    public var childCoordinators: [any Coordinator] = []
    public let navigationController: UINavigationController

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public enum Flow {
        case analysis(imageData: Data)
    }

    public func start() {
        let cameraRepository = DefaultCameraRepository()
        let cameraUseCase = DefaultCameraUseCase(repository: cameraRepository)
        let cameraViewModel = CameraViewModel(cameraUseCase: cameraUseCase)
        let cameraViewController = CameraViewController(viewModel: cameraViewModel)


        self.navigationController.pushViewController(cameraViewController, animated: true)
    }
}
