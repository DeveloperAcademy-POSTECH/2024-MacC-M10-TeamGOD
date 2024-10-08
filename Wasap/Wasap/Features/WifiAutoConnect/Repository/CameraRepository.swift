//
//  CameraRepository.swift
//  Wasap
//
//  Created by chongin on 10/7/24.
//

import RxSwift
import AVFoundation

protocol CameraRepository {
    func configureCamera() -> Single<AVCaptureSession>
    func startMonitoring()
    func stopMonitoring()
    func capturePhoto() -> Single<Data>
}

class DefaultCameraRepository: NSObject, CameraRepository {
    private var captureSession: AVCaptureSession?
    private var stillImageOutput: AVCapturePhotoOutput?
    private var photoCaptureCompletion: ((Result<Data, Error>) -> Void)?

    // 카메라 프리뷰 설정
    func configureCamera() -> Single<AVCaptureSession> {
        return Single.create { single in
            let session = AVCaptureSession()
            session.sessionPreset = .photo

            guard let backCamera = AVCaptureDevice.default(for: .video) else {
                single(.failure(NSError(domain: "CameraError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Back camera not found"])))
                return Disposables.create()
            }

            do {
                let input = try AVCaptureDeviceInput(device: backCamera)
                session.addInput(input)

                self.stillImageOutput = AVCapturePhotoOutput()
                if session.canAddOutput(self.stillImageOutput!) {
                    session.addOutput(self.stillImageOutput!)
                }

                self.captureSession = session
                single(.success(session))
            } catch {
                single(.failure(error))
            }

            return Disposables.create {
                session.stopRunning()
            }
        }
    }

    // 사진 촬영
    func capturePhoto() -> Single<Data> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.failure(NSError(domain: "ObjectError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Object of this method is nil"])))
                return Disposables.create()
            }
            guard let stillImageOutput = self.stillImageOutput else {
                single(.failure(NSError(domain: "PhotoError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Still image output not available"])))
                return Disposables.create()
            }

            let settings = AVCapturePhotoSettings()
            self.photoCaptureCompletion = { result in
                switch result {
                case .success(let data):
                    single(.success(data))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            stillImageOutput.capturePhoto(with: settings, delegate: self)

            return Disposables.create()
        }
    }

    func startMonitoring() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession?.startRunning()
        }
    }

    func stopMonitoring() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession?.stopRunning()
        }
    }
}

extension DefaultCameraRepository: AVCapturePhotoCaptureDelegate {

    // 사진 처리 완료 시 호출
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error {
            photoCaptureCompletion?(.failure(error))
        } else if let imageData = photo.fileDataRepresentation() {
            photoCaptureCompletion?(.success(imageData))
        } else {
            photoCaptureCompletion?(.failure(NSError(domain: "PhotoError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Failed to process photo data"])))
        }
    }
}
