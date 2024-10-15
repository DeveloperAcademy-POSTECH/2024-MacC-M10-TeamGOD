//
//  ConnectingCoordinator.swift
//  Wasap
//
//  Created by Chang Jonghyeon on 10/14/24.
//

import UIKit

public protocol ConnectingCoordinatorController: AnyObject {
    func performTransition(to flow: ConnectingCoordinator.Flow)
}

public class ConnectingCoordinator: NavigationCoordinator {
    public var childCoordinators: [any Coordinator] = []
    public let navigationController: UINavigationController
    let wifiAutoConnectDIContainer: WifiAutoConnectDIContainer

    let ssid: String?
    let password: String?

    private weak var connectingViewController: ConnectingViewController?
    
    public init(navigationController: UINavigationController, wifiAutoConnectDIContainer: WifiAutoConnectDIContainer, ssid: String?, password: String?) {
        self.navigationController = navigationController
        self.wifiAutoConnectDIContainer = wifiAutoConnectDIContainer
        self.ssid = ssid
        self.password = password
    }
    
    public enum Flow {
        case detail
    }
    
    public func start() {
        let wifiConnectRepository = wifiAutoConnectDIContainer.makeWiFiConnectRepository()
        let wifiConnectUseCase = wifiAutoConnectDIContainer.makeWiFiConnectUseCase(wifiConnectRepository)
        
        let viewModel = wifiAutoConnectDIContainer.makeConnectingViewModel(wifiConnectUseCase: wifiConnectUseCase, coordinatorcontroller: self, ssid: ssid ?? "", password: password ?? "")
        let viewController = wifiAutoConnectDIContainer.makeConnectingViewController(viewModel)
        
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension ConnectingCoordinator: ConnectingCoordinatorController {
    public func performTransition(to flow: Flow) {
        switch flow {
        case .detail:
            print("Performing transition to detail flow")
        }
    }
}
