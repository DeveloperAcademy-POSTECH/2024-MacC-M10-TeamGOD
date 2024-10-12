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
        case detail
    }
    

    public func start() {
        /*
        let wifiConnectCoordinator = WifiConnectCoordinator(navigationController: UINavigationController())
        start(childCoordinator: wifiConnectCoordinator)
        window?.rootViewController = wifiConnectCoordinator.navigationController
        window?.makeKeyAndVisible()
        */
        
        let scanCoordinator = ScanCoordinator(navigationController: UINavigationController(), wifiAutoConnectDIContainer: appDIContainer.makeWifiAutoConnectDIContainer())
        start(childCoordinator: scanCoordinator)
        window?.rootViewController = scanCoordinator.navigationController
        window?.makeKeyAndVisible()
        
    }
}
