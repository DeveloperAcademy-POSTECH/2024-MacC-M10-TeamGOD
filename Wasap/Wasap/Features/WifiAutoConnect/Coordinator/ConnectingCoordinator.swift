//
//  ConnectingCoordinator.swift
//  Wasap
//
//  Created by Chang Jonghyeon on 10/14/24.
//

import UIKit

public protocol ConnectingCoordinatorController: AnyObject {
//    func performTransition(to flow: ConnectingCoordinator.Flow)
    func performFinish(to flow: ConnectingCoordinator.FinishFlow)
}

public class ConnectingCoordinator: NavigationCoordinator {
    public var parentCoordinator: (any Coordinator)? = nil
    public var childCoordinators: [any Coordinator] = []
    public let navigationController: UINavigationController
    let wifiAutoConnectDIContainer: WifiAutoConnectDIContainer

    let imageData: UIImage
    let ssid: String?
    let password: String?

    private weak var connectingViewController: ConnectingViewController?
    
    public init(navigationController: UINavigationController, wifiAutoConnectDIContainer: WifiAutoConnectDIContainer, imageData: UIImage, ssid: String?, password: String?) {
        self.navigationController = navigationController
        self.wifiAutoConnectDIContainer = wifiAutoConnectDIContainer
        self.ssid = ssid
        self.password = password
        self.imageData = imageData
    }
    
//    public enum Flow {
//        case last(imageData: UIImage, ssid : String, password : String)
//        case retry(imageData: UIImage, ssid : String, password : String)
//        case camera
//    }

    public enum FinishFlow {
        case popToRoot
        case finishWithError
    }

    public func start() {
        let wifiConnectRepository = wifiAutoConnectDIContainer.makeWiFiConnectRepository()
        let wifiConnectUseCase = wifiAutoConnectDIContainer.makeWiFiConnectUseCase(wifiConnectRepository)
        
        let viewModel = wifiAutoConnectDIContainer.makeConnectingViewModel(wifiConnectUseCase: wifiConnectUseCase, coordinatorcontroller: self, imageData: imageData, ssid: ssid ?? "", password: password ?? "")
        let viewController = wifiAutoConnectDIContainer.makeConnectingViewController(viewModel)
        
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(viewController, animated: true)
    }

    public func finish() {
        self.navigationController.popViewController(animated: true)
    }
}

extension ConnectingCoordinator: ConnectingCoordinatorController {
//    public func performTransition(to flow: Flow) {
//        switch flow {
//        case .last(let imageData,ssid: let ssid, password: let password):
//            let coordinator = GoToSettingCoordinator(navigationController: self.navigationController, wifiAutoConnectDIContainer: wifiAutoConnectDIContainer, imageData: imageData, ssid: ssid, password: password)
//            start(childCoordinator: coordinator)
//
//        case .camera:
//            print("Camara View")
//            let coordinator = CameraCoordinator(navigationController: self.navigationController, wifiAutoConnectDIContainer: wifiAutoConnectDIContainer)
//            start(childCoordinator: coordinator)
//
//        case .retry(imageData: let imageData, ssid: let ssid, password: let password):
//            print("Retry View")
//
//        }
//    }

    public func performFinish(to flow: FinishFlow) {
        switch flow {
        case .popToRoot:
            finishUntil(CameraCoordinator.self)
        case .finishWithError:
            if let parentCoordinator = parentCoordinator as? ScanCoordinator {
                finishCurrentCoordinator()
                parentCoordinator.performTransition(to: .retry(imageData: imageData, ssid: ssid, password: password))
            } else if let parentCoordinator = parentCoordinator as? WifiConnectCoordinator {
                finishCurrentCoordinator()
                parentCoordinator.performTransition(to: .gotoSetting(imageData: imageData, ssid: ssid ?? "", password: password ?? ""))
            }
        }
    }
}
