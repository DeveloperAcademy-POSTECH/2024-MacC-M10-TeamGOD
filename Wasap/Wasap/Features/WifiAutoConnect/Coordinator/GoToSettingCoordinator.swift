//
//  GotoSettingCoordinator.swift
//  Wasap
//
//  Created by 김상준 on 10/15/24.
//

import Foundation
import UIKit

public class GoToSettingCoordinator: NavigationCoordinator {
    public var parentCoordinator: (any Coordinator)? = nil
    public var childCoordinators: [any Coordinator] = []
    public let navigationController: UINavigationController
    private let wifiAutoConnectDIContainer: WifiAutoConnectDIContainer

    let imageData : UIImage
    let ssid : String
    let password : String

    public init(navigationController: UINavigationController,
                wifiAutoConnectDIContainer: WifiAutoConnectDIContainer,
                imageData: UIImage, ssid: String, password: String) {
        Log.print("GoToSettingCoordinator에서 받은 image: \(imageData), ssid: \(ssid), password: \(password)")
        self.navigationController = navigationController
        self.wifiAutoConnectDIContainer = wifiAutoConnectDIContainer
        self.imageData = imageData
        self.ssid = ssid
        self.password = password
    }

    public enum FinishFlow {
        case popToRoot
    }

    public func start() {
        let repository = DefaultGoToSettingRepository()
        let usecase = DefaultGoToSettingUseCase(repository: repository)
        let viewModel = GoToSettingViewModel(
            gotoSettingUseCase: usecase,
            coordinatorController: self, imageData: imageData,
            ssid: ssid, password: password)

        let viewController = GoToSettingViewController(viewModel: viewModel)

        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(viewController, animated: true)
    }

    public func finish() {
        self.navigationController.popViewController(animated: true)
    }
}

extension GoToSettingCoordinator: GoToSettingCoordinatorController {

    public func performFinish(to flow: FinishFlow) {
        switch flow {
        case .popToRoot:
            finishUntil(CameraCoordinator.self)

        }
    }
}

