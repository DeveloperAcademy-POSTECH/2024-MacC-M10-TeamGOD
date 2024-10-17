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

    let ssid : String
    let password : String
    let imageData : UIImage

    public init(navigationController: UINavigationController, wifiAutoConnectDIContainer: WifiAutoConnectDIContainer, imageData: UIImage, ssid: String, password: String) {
        Log.print("GoToSettingCoordinator에서 받은 image: \(imageData), ssid: \(ssid), password: \(password)")
        self.navigationController = navigationController
        self.wifiAutoConnectDIContainer = wifiAutoConnectDIContainer
        self.ssid = ssid
        self.password = password
        self.imageData = imageData
    }
    
    public enum Flow {
       case camera
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
    public func performTransition(to flow: Flow) {
        switch flow {
        case .camera:
            finishUntil(CameraCoordinator.self)
        }

    }
}

