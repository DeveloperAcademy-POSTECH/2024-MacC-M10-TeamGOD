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

final class CameraUseCase {
    private let repository: CameraRepository

    init(repository: CameraRepository) {
        self.repository = repository
    }

    func startCameraPreview() -> Single<AVCaptureSession> {
        return repository.configureCamera()
    }

    func takePhoto() -> Single<Data> {
        return repository.capturePhoto()
    }

    func startRunning() {
        repository.startMonitoring()
    }

    func stopRunning() {
        repository.stopMonitoring()
    }
}
