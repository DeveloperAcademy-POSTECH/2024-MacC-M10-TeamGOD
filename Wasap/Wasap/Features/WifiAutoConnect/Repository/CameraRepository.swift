//
//  CameraRepository.swift
//  Wasap
//
//  Created by chongin on 10/7/24.
//

import RxSwift
import AVFoundation

protocol CameraRepository {

    /// configureCamera : 카메라의 초기 설정을 담당. Input과 Output을 지정함.
    /// configure과 previewLayer 세팅이 끝나면 startRunning() 함수로 시작하세요.
    func configureCamera() -> Single<AVCaptureSession>

    /// getPreviewLayer : 프리뷰 레이어를 가져옵니다. 뷰에서 이 레이어를 활용하세요.
    func getPreviewLayer() -> Single<AVCaptureVideoPreviewLayer>

    /// startRunning() : 카메라 프리뷰를 시작합니다. 캡쳐 대기를 합니다.
    func startRunning()

    /// stopRunning() : 카메라 프리뷰를 중지합니다. 캡쳐 대기를 종료합니다.
    func stopRunning()

    /// capturePhoto() : 캡쳐를 수행합니다. 그 결과를 Single로 받습니다.
    func capturePhoto() -> Single<Data>
}

class DefaultCameraRepository: NSObject, CameraRepository {
    private var captureSession: AVCaptureSession?
    
    private var stillImageOutput: AVCapturePhotoOutput?
    private var photoCaptureCompletion: ((Result<Data, Error>) -> Void)?

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

    func getPreviewLayer() -> Single<AVCaptureVideoPreviewLayer> {
        Single.create { [weak self] single in
            guard let captureSession = self?.captureSession else {
                Log.error("아이고.. configure camera를 먼저 해줘야 해요.")
                single(.failure(CameraErrors.previewLayerError))
                return Disposables.create()
            }
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            single(.success(previewLayer))
            return Disposables.create()
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
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
            Log.print("Camera started running")
        }
    }

    func stopRunning() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.stopRunning()
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
