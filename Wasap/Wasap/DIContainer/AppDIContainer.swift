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
    
    public func makeImageAnalysisUseCase(_ repository: ImageAnalysisRepository) -> ImageAnalysisUseCase {
        return DefaultImageAnalysisUseCase(imageAnalysisRepository: repository)
    }
    
    public func makeScanViewModel(_ useCase: ImageAnalysisUseCase, coordinatorcontroller: ScanCoordinatorController, image: UIImage) -> ScanViewModel {
        return ScanViewModel(imageAnalysisUseCase: useCase, coordinatorController: coordinatorcontroller, previewImage: image)
    }
    
    public func makeScanViewController(_ viewModel: ScanViewModel) -> ScanViewController {
        return ScanViewController(viewModel: viewModel)
    }
}
