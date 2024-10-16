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

    public func makeCameraRepository() -> CameraRepository {
        return DefaultCameraRepository()
    }

    public func makeImageAnalysisUseCase(_ repository: ImageAnalysisRepository) -> ImageAnalysisUseCase {
        return DefaultImageAnalysisUseCase(imageAnalysisRepository: repository)
    }

    public func makeWiFiConnectUseCase(_ repository: WiFiConnectRepository) -> WiFiConnectUseCase {
        return DefaultWiFiConnectUseCase(repository: repository)
    }

    public func makeCameraUseCase(_ repository: CameraRepository) -> CameraUseCase {
        return DefaultCameraUseCase(repository: repository)
    }

    public func makeScanViewModel(imageAnalysisUseCase: ImageAnalysisUseCase, coordinatorcontroller: ScanCoordinatorController, image: UIImage) -> ScanViewModel {
        return ScanViewModel(imageAnalysisUseCase: imageAnalysisUseCase, coordinatorController: coordinatorcontroller, previewImage: image)
    }

    public func makeWifiConnectViewModel(wifiConnectUseCase: WiFiConnectUseCase, coordinatorcontroller: WifiConnectCoordinatorController, imageData: UIImage, ssid: String, password: String) -> WifiConnectViewModel {
        return WifiConnectViewModel(wifiConnectUseCase: wifiConnectUseCase, coordinatorController: coordinatorcontroller, image: imageData, ssid: ssid, password: password)
    }

    public func makeConnectingViewModel(wifiConnectUseCase: WiFiConnectUseCase, coordinatorcontroller: ConnectingCoordinatorController, imageData: UIImage, ssid: String, password: String) -> ConnectingViewModel {
        return ConnectingViewModel(wifiConnectUseCase: wifiConnectUseCase, coordinatorController: coordinatorcontroller,image: imageData, ssid: ssid, password: password)
    }

    public func makeCameraViewModel(cameraUseCase: CameraUseCase, coordinatorcontroller: CameraCoordinatorController) -> CameraViewModel {
        return CameraViewModel(cameraUseCase: cameraUseCase, coordinatorController: coordinatorcontroller)
    }

    public func makeScanViewController(_ viewModel: ScanViewModel) -> ScanViewController {
        return ScanViewController(viewModel: viewModel)
    }

    public func makeConnectingViewController(_ viewModel: ConnectingViewModel) -> ConnectingViewController {
        return ConnectingViewController(viewModel: viewModel)
    }

    public func makeWifiReConnectViewController(_ viewModel: WifiConnectViewModel) -> WifiReConnectViewController {
        return WifiReConnectViewController(viewModel: viewModel)
    }

    public func makeCameraViewController(_ viewModel: CameraViewModel) -> CameraViewController {
        return CameraViewController(viewModel: viewModel)
    }
}
