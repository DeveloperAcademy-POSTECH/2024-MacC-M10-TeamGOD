//
//  CameraUseCase.swift
//  Wasap
//
//  Created by chongin on 10/6/24.
//

import Foundation
import UIKit
import RxSwift
import AVFoundation

protocol CameraUseCase {
    func configureCamera() -> Single<Void>
    func takePhoto() -> Single<UIImage>
    func getCapturePreviewLayer() -> Single<AVCaptureVideoPreviewLayer>
    func startRunning()
    func stopRunning()
}

final class DefaultCameraUseCase: CameraUseCase {
    private let repository: CameraRepository

    init(repository: CameraRepository) {
        self.repository = repository
    }

    func configureCamera() -> Single<Void> {
        return repository.configureCamera()
            .map { _ in () }
    }

    func takePhoto() -> Single<UIImage> {
        return repository.capturePhoto()
            .map {
                guard let image = UIImage(data: $0) else {
                    throw CameraErrors.imageConvertError
                }
                return image
            }
    }

    func getCapturePreviewLayer() -> Single<AVCaptureVideoPreviewLayer> {
        Single.create { [weak self] single in
            guard let previewLayer = self?.repository.previewLayer else {
                single(.failure(CameraErrors.previewLayerError))
                return Disposables.create()
            }
            single(.success(previewLayer))
            return Disposables.create()
        }
    }

    func startRunning() {
        repository.startRunning()
    }

    func stopRunning() {
        repository.stopRunning()
    }
}
