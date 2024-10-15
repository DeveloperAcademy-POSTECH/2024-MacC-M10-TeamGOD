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
    private weak var coordinatorController: CameraCoordinatorController?

    // MARK: - UseCase
    private let cameraUseCase: CameraUseCase

    // MARK: - Input
    public var zoomValue = BehaviorRelay<CGFloat>(value: 1.0)
    public var zoomControlButtonDidTap = PublishRelay<Void>()

    // MARK: - Output
    public var previewLayer: Driver<AVCaptureVideoPreviewLayer>
    public var isZoomControlButtonHidden: Driver<Bool>

    // MARK: - Properties
    private var isCameraRunning = BehaviorRelay<Bool>(value: false)

    // MARK: - Init & Binding
    public init(cameraUseCase: CameraUseCase) {
        self.cameraUseCase = cameraUseCase
        let previewLayerRelay = PublishRelay<AVCaptureVideoPreviewLayer>()
        self.previewLayer = previewLayerRelay.asDriver(onErrorDriveWith: .empty())

        let isZoomControlButtonHiddenRelay = BehaviorRelay<Bool>(value: false)
        self.isZoomControlButtonHidden = isZoomControlButtonHiddenRelay.asDriver(onErrorDriveWith: .empty())

        super.init()
        let isCameraConfigured = PublishRelay<Void>()

        viewDidLoad
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                cameraUseCase.configureCamera()
            }
            .subscribe {
                Log.debug("Camera Configure Completed")
                isCameraConfigured.accept($0)
            } onError: { error in
                Log.error("\(error.localizedDescription)")
            }
            .disposed(by: disposeBag)


        isCameraConfigured
            .withUnretained(self)
            .flatMapLatest { owner, _  in
                owner.cameraUseCase.startRunning()
            }
            .withUnretained(self)
            .subscribe { owner, _ in
                Log.debug("Camera start running")
                owner.isCameraRunning.accept(true)
            } onError: { error in
                Log.error(error.localizedDescription)
            }
            .disposed(by: disposeBag)

        isCameraRunning
            .filter { $0 }
            .withUnretained(self)
            .flatMapLatest { owner, _ -> Single<AVCaptureVideoPreviewLayer> in
                owner.cameraUseCase.getCapturePreviewLayer()
            }
            .subscribe {
                previewLayerRelay.accept($0)
            } onError: { error in
                Log.error(error.localizedDescription)
            }
            .disposed(by: disposeBag)

        Observable.combineLatest(isCameraRunning, zoomValue)
            .filter(\.0)
            .subscribe { [weak self] _, value in
                self?.cameraUseCase.zoom(value)
            }
            .disposed(by: disposeBag)

        zoomValue
            .debounce(.seconds(3), scheduler: MainScheduler.instance)
            .map { _ in false }
            .bind(to: isZoomControlButtonHiddenRelay)
            .disposed(by: disposeBag)

        zoomControlButtonDidTap
            .map { _ in true }
            .bind(to: isZoomControlButtonHiddenRelay)
            .disposed(by: disposeBag)
    }
}
