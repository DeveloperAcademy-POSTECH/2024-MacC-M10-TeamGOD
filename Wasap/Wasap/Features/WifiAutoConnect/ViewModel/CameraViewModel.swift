//
//  CameraViewModel.swift
//  Wasap
//
//  Created by chongin on 10/10/24.
//

import RxSwift
import RxCocoa
import AVFoundation

public class CameraViewModel: BaseViewModel {
    // MARK: - Coordinator

    // MARK: - UseCase
    private let cameraUseCase: CameraUseCase

    // MARK: - Input
    public var startCamera = PublishRelay<Void>()

    // MARK: - Output
    public var previewLayer: Driver<AVCaptureVideoPreviewLayer>

    // MARK: - Init & Binding
    public init(cameraUseCase: CameraUseCase) {
        self.cameraUseCase = cameraUseCase
        let previewLayerRelay = PublishRelay<AVCaptureVideoPreviewLayer>()
        self.previewLayer = previewLayerRelay.asDriver(onErrorDriveWith: .empty())

        super.init()
        let setupPreviewLayer = PublishRelay<Void>()

        viewDidLoad
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                cameraUseCase.configureCamera()
            }
            .bind(to: setupPreviewLayer)
            .disposed(by: disposeBag)

        setupPreviewLayer
            .withUnretained(self)
            .flatMapLatest { owner, _ -> Single<AVCaptureVideoPreviewLayer> in
                owner.cameraUseCase.getCapturePreviewLayer()
            }
            .bind(to: previewLayerRelay)
            .disposed(by: disposeBag)

        startCamera
            .withUnretained(self)
            .subscribe { owner, _ in
                cameraUseCase.startRunning()
            }
            .disposed(by: disposeBag)
    }
}
