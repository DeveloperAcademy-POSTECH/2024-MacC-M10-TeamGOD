//
//  SampleCoordinator.swift
//  Wasap
//
//  Created by 김상준 on 10/7/24.
//

import Foundation
import UIKit

public class WifiConnectCoordinator: NavigationCoordinator {
    public var childCoordinators: [any Coordinator] = []
    public let navigationController: UINavigationController

    let ssid : String
    let password: String

    public init(navigationController: UINavigationController, ssid: String, password: String) {
        self.navigationController = navigationController
        self.ssid = ssid
        self.password = password
    }
    
    public enum Flow {
        case connecting(ssid : String, password: String)
        case camera
    }

    public func start() {
        let repository = DefaultWiFiConnectRepository()
        let usecase = DefaultWiFiConnectUseCase(repository: repository)
        let viewModel = WifiConnectViewModel(wifiConnectUseCase: usecase, coordinatorController: self)
        let viewController = WifiReConnectViewController(viewModel: viewModel)
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension WifiConnectCoordinator: WifiConnectCoordinatorController {
    public func performTransition(to flow: Flow) {
        switch flow {
        case .camera:
            print("Camara View")
            let coordinator = CameraCoordinator(navigationController: self.navigationController)
            start(childCoordinator: coordinator)

        case .connecting(let ssid, let password):
            let coordinator = ConnectingCoordinator(navigationController: self.navigationController, wifiAutoConnectDIContainer: WifiAutoConnectDIContainer(), ssid: ssid, password: password)
            start(childCoordinator: coordinator)
        }

    }
}

