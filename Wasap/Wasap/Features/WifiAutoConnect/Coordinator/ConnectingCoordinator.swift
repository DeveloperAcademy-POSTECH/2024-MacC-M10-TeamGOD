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
    
    private weak var connectingViewController: ConnectingViewController?
    
    public init(navigationController: UINavigationController, wifiAutoConnectDIContainer: WifiAutoConnectDIContainer) {
        self.navigationController = navigationController
        self.wifiAutoConnectDIContainer = wifiAutoConnectDIContainer
    }
    
    public enum Flow {
        case detail
    }
    
    public func start() {
        let wifiConnectRepository = wifiAutoConnectDIContainer.getWiFiConnectRepository()
        
        let wifiConnectUseCase = wifiAutoConnectDIContainer.makeWiFiConnectUseCase(wifiConnectRepository!)
        
        let viewModel = wifiAutoConnectDIContainer.makeConnectingViewModel(wifiConnectUseCase: wifiConnectUseCase, coordinatorcontroller: self)
        let viewController = wifiAutoConnectDIContainer.makeConnectingViewController(viewModel)
        
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
