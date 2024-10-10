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
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public enum Flow {
        case detail
    }

    public func start() {
        let repository = DefaultWifiConnectRepository()
        
        let usecase = DefaultWiFiConnectUseCase(repository: repository)
        
        let viewModel = WifiConnectViewModel(wifiConnectUseCase: usecase, coordinatorController: self)
        
        let viewController = WifiConnectViewController(viewModel: viewModel)
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension WifiConnectCoordinator: WifiConnectCoordinatorController {
    public func performTransition(to flow: Flow) {
        switch flow {
        case .detail:
            let coordinator = WifiConnectCoordinator(navigationController: self.navigationController)
            start(childCoordinator: coordinator)
            Log.debug("Detail Flow!")
        }
    }
    

}
