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

    let image: UIImage
    let ssid : String
    let password: String

    public init(navigationController: UINavigationController,image: UIImage, ssid: String, password: String) {
        self.navigationController = navigationController
        self.image = image
        self.ssid = ssid
        self.password = password
    }
    
    public enum Flow {
        case connecting(imageData: UIImage,ssid : String, password : String)
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

        case .connecting(imageData: let imageData,ssid: let ssid, password: let password):
            let coordinator = ConnectingCoordinator(navigationController: self.navigationController, wifiAutoConnectDIContainer: WifiAutoConnectDIContainer(),imageData: imageData, ssid: ssid, password: password)
            start(childCoordinator: coordinator)
        }

    }
}

