//
//  AppDIContainer.swift
//  Wasap
//
//  Created by chongin on 9/29/24.
//

import UIKit

final public class AppDIContainer {
    let apiClient: APIClient
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    public func makeWifiAutoConnectDIContainer() -> WifiAutoConnectDIContainer {
        return WifiAutoConnectDIContainer()
    }
}

final public class WifiAutoConnectDIContainer {

    public func makeImageAnalysisRepository() -> ImageAnalysisRepository {
        return DefaultImageAnalysisRepository()
    }

    public func makeWiFiConnectRepository() -> WiFiConnectRepository {
        return DefaultWiFiConnectRepository()
    }

    public func makeImageAnalysisUseCase(_ repository: ImageAnalysisRepository) -> ImageAnalysisUseCase {
        return DefaultImageAnalysisUseCase(imageAnalysisRepository: repository)
    }

    public func makeWiFiConnectUseCase(_ repository: WiFiConnectRepository) -> WiFiConnectUseCase {
        return DefaultWiFiConnectUseCase(repository: repository)
    }

    public func makeScanViewModel(imageAnalysisUseCase: ImageAnalysisUseCase, coordinatorcontroller: ScanCoordinatorController, image: UIImage) -> ScanViewModel {
        return ScanViewModel(imageAnalysisUseCase: imageAnalysisUseCase, coordinatorController: coordinatorcontroller, previewImage: image)
    }

    public func makeScanViewController(_ viewModel: ScanViewModel) -> ScanViewController {
        return ScanViewController(viewModel: viewModel)
    }

    public func makeConnectingViewModel(wifiConnectUseCase: WiFiConnectUseCase, coordinatorcontroller: ConnectingCoordinatorController,imageData: UIImage, ssid: String, password: String) -> ConnectingViewModel {
        return ConnectingViewModel(wifiConnectUseCase: wifiConnectUseCase, coordinatorController: coordinatorcontroller,image: imageData, ssid: ssid, password: password)
    }

    public func makeConnectingViewController(_ viewModel: ConnectingViewModel) -> ConnectingViewController {
        return ConnectingViewController(viewModel: viewModel)
    }
}
