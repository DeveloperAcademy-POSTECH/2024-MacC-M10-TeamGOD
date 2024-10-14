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
    let previewImage: UIImage = .init(named: "previewTestImage2")!
    
    private weak var scanViewController: ScanViewController?
    
    public init(navigationController: UINavigationController, wifiAutoConnectDIContainer: WifiAutoConnectDIContainer/*, previewImage: UIImage*/) {
        self.navigationController = navigationController
        self.wifiAutoConnectDIContainer = wifiAutoConnectDIContainer
        
        // self.previewImage = previewImage
    }
    
    public enum Flow {
        case detail(imageData: Data)
        // case previewImage(UIImage)
    }
    
    public func start() {
        // ImageAnalysis Repository, UseCase, ViewModel, ViewController 생성
        let imageAnalysisRepository = wifiAutoConnectDIContainer.makeImageAnalysisRepository()
        let imageAnalysisUseCase = wifiAutoConnectDIContainer.makeImageAnalysisUseCase(imageAnalysisRepository)
        
        let wifiConnectRepository = wifiAutoConnectDIContainer.makeWiFiConnectRepository()
        let wifiConnectUseCase = wifiAutoConnectDIContainer.makeWiFiConnectUseCase(wifiConnectRepository)
        
        let viewModel = wifiAutoConnectDIContainer.makeScanViewModel(imageAnalysisUseCase: imageAnalysisUseCase, wifiConnectUseCase: wifiConnectUseCase, coordinatorcontroller: self, image: previewImage)
        let viewController = wifiAutoConnectDIContainer.makeScanViewController(viewModel)
        
        // ImageAnalysisViewController를 navagationController에 push
        self.navigationController.pushViewController(viewController, animated: true)
        
        self.scanViewController = viewController
    }
}

extension ScanCoordinator: ScanCoordinatorController {
    public func performTransition(to flow: Flow) {
        switch flow {
        case .detail:
            print("Performing transition to detail flow")
        // case .previewImage(UIImage)
        }
    }
}
