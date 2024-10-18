//
//  RootCoordinator.swift
//  Wasap
//
//  Created by chongin on 10/3/24.
//

import UIKit

public class RootCoordinator: Coordinator {
    public var parentCoordinator: (any Coordinator)? = nil

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
        let coordinator = WifiReConnectCoordinator(navigationController: UINavigationController(), wifiAutoConnectDIContainer: appDIContainer.makeWifiAutoConnectDIContainer(),image: UIImage(),ssid: "",password: "")
        start(childCoordinator: coordinator)
        window?.rootViewController = coordinator.navigationController
        window?.makeKeyAndVisible()
    }

//    public func start() {
//        let scanCoordinator = CameraCoordinator(navigationController: UINavigationController(), wifiAutoConnectDIContainer: appDIContainer.makeWifiAutoConnectDIContainer())
//        start(childCoordinator: scanCoordinator)
//        window?.rootViewController = scanCoordinator.navigationController
//        window?.makeKeyAndVisible()
//    }

    public func finish() {
        fatalError("You cannot finish Root Coordinator")
    }
}
