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

public protocol CameraUseCase {
    func configureCamera() -> Single<Void>
    func takePhoto() -> Single<UIImage>
    func getCapturePreviewLayer() -> Single<AVCaptureVideoPreviewLayer>
    func startRunning() -> Single<Void>
    func stopRunning()
    func zoom(_ factor: CGFloat)
}

final class DefaultCameraUseCase: CameraUseCase {
    private let repository: CameraRepository

    init(repository: CameraRepository) {
        self.repository = repository
    }

    func configureCamera() -> Single<Void> {
        Log.debug("Configure camera")
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
        Log.debug("Get Capture Preview Layer")
        return repository.getPreviewLayer()
    }

    func startRunning() -> Single<Void> {
        Log.debug("Start Running")
        return repository.startRunning()
    }

    func stopRunning() {
        repository.stopRunning()
    }

    func zoom(_ factor: CGFloat) {
        repository.zoom(factor)
    }
}
