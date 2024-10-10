//
//  CameraRepository.swift
//  Wasap
//
//  Created by chongin on 10/7/24.
//

import RxSwift
import AVFoundation

protocol CameraRepository {
    /// previewLayer : 프리뷰 레이어. 이 레이어를 뷰에서 활용하세요.
    var previewLayer: AVCaptureVideoPreviewLayer? { get }

    /// configureCamera : 카메라의 초기 설정을 담당. Input과 Output을 지정함.
    /// configure과 previewLayer 세팅이 끝나면 startRunning() 함수로 시작하세요.
    func configureCamera() -> Single<AVCaptureSession>

    /// startRunning() : 카메라 프리뷰를 시작합니다. 캡쳐 대기를 합니다.
    func startRunning()

    /// stopRunning() : 카메라 프리뷰를 중지합니다. 캡쳐 대기를 종료합니다.
    func stopRunning()

    /// capturePhoto() : 캡쳐를 수행합니다. 그 결과를 Single로 받습니다.
    func capturePhoto() -> Single<Data>
}

class DefaultCameraRepository: NSObject, CameraRepository {
    private var captureSession: AVCaptureSession? {
        didSet {
            guard let captureSession else { return }
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            self.previewLayer = previewLayer
        }
    }
    
    private var stillImageOutput: AVCapturePhotoOutput?
    private var photoCaptureCompletion: ((Result<Data, Error>) -> Void)?
    var previewLayer: AVCaptureVideoPreviewLayer? = nil

    func configureCamera() -> Single<AVCaptureSession> {
        return Single.create { [weak self] single in
            let session = AVCaptureSession()
            session.sessionPreset = .photo

            guard let backCamera = AVCaptureDevice.default(for: .video) else {
                single(.failure(CameraErrors.cameraNotFound))
                return Disposables.create()
            }

            do {
                let input = try AVCaptureDeviceInput(device: backCamera)
                session.addInput(input)

                self?.stillImageOutput = AVCapturePhotoOutput()
                if session.canAddOutput((self?.stillImageOutput!)!) {
                    session.addOutput((self?.stillImageOutput!)!)
                }

                self?.captureSession = session
                single(.success(session))
            } catch {
                single(.failure(CameraErrors.captureDeviceError))
            }

            return Disposables.create {
                session.stopRunning()
            }
        }
    }

    func capturePhoto() -> Single<Data> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.failure(CameraErrors.unknown))
                return Disposables.create()
            }
            guard let stillImageOutput = self.stillImageOutput else {
                single(.failure(CameraErrors.imageOutputNotAvailable))
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

    func startRunning() {
        DispatchQueue.main.async {
            self.captureSession?.startRunning()
        }
    }

    func stopRunning() {
        DispatchQueue.main.async {
            self.captureSession?.stopRunning()
        }
    }
}

extension DefaultCameraRepository: AVCapturePhotoCaptureDelegate {

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error {
            photoCaptureCompletion?(.failure(error))
        } else if let imageData = photo.fileDataRepresentation() {
            photoCaptureCompletion?(.success(imageData))
        } else {
            photoCaptureCompletion?(.failure(CameraErrors.photoProcessingError))
        }
    }
}
