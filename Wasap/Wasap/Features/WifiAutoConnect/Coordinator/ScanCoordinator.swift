//
//  ScanCoordinator.swift
//  Wasap
//
//  Created by Chang Jonghyeon on 10/10/24.
//

import UIKit

public protocol ScanCoordinatorController: AnyObject {
    func performTransition(to flow: ScanCoordinator.Flow)
}

public class ScanCoordinator: NavigationCoordinator {
    public var childCoordinators: [any Coordinator] = []
    public let navigationController: UINavigationController
    let wifiAutoConnectDIContainer: WifiAutoConnectDIContainer
    let previewImage: UIImage = .init(named: "previewTestImage4")!

    public init(navigationController: UINavigationController, wifiAutoConnectDIContainer: WifiAutoConnectDIContainer/*, previewImage: UIImage*/) {
        self.navigationController = navigationController
        self.wifiAutoConnectDIContainer = wifiAutoConnectDIContainer
        
        // self.previewImage = previewImage
    }
    
    public enum Flow {
        case connecting(ssid: String, password: String)
    }
    
    public func start() {
        // Repository, UseCase, ViewModel, ViewController 생성
        let imageAnalysisRepository = wifiAutoConnectDIContainer.makeImageAnalysisRepository()
        let imageAnalysisUseCase = wifiAutoConnectDIContainer.makeImageAnalysisUseCase(imageAnalysisRepository)
        
        let viewModel = wifiAutoConnectDIContainer.makeScanViewModel(imageAnalysisUseCase: imageAnalysisUseCase, coordinatorcontroller: self, image: previewImage)
        let viewController = wifiAutoConnectDIContainer.makeScanViewController(viewModel)
        
        // ScanViewController를 navagationController에 push
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension ScanCoordinator: ScanCoordinatorController {
    public func performTransition(to flow: Flow) {
        switch flow {
        case .connecting(let ssid, let password):
            let coordinator = ConnectingCoordinator(navigationController: self.navigationController, wifiAutoConnectDIContainer: self.wifiAutoConnectDIContainer, ssid: ssid, password: password)
            start(childCoordinator: coordinator)
        }
    }
}
