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
        let repository = DefaultWiFiConnectRepository()
        
        let usecase = DefaultWiFiConnectUseCase(repository: repository)
        
        let viewModel = WifiConnectViewModel(wifiConnectUseCase: usecase, coordinatorController: self)
        
        let viewController = WifiReConnectViewController(viewModel: viewModel)
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension WifiConnectCoordinator: WifiConnectTranslater {
    func perfromTransition(_ flow: WifiConnectCoordinator.Flow) {
        switch flow {
        case .detail:
            navigationController.pushViewController(
                CameraViewController(cameraUseCase: DefaultCameraUseCase(repository: CameraRepository.self as! CameraRepository)), animated: true)
        }
    }
}
