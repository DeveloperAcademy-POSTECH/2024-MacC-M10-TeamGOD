//
//  CameraUseCaseTests.swift
//  Wasap
//
//  Created by chongin on 10/7/24.
//

import RxSwift
import AVFoundation
@testable import Wasap
import Testing
import RxSwift
import RxBlocking
import UIKit

class MockCameraRepository: NSObject, CameraRepository {
    var captureSession: AVCaptureSession?
    private var stillImageOutput: AVCapturePhotoOutput?

    // 카메라 프리뷰 설정
    func configureCamera() -> Single<AVCaptureSession> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            let mockSession = AVCaptureSession()
            mockSession.sessionPreset = .photo

            self.stillImageOutput = AVCapturePhotoOutput()
            if mockSession.canAddOutput(self.stillImageOutput!) {
                mockSession.addOutput(self.stillImageOutput!)
            }

            self.captureSession = mockSession
            single(.success(mockSession))

            return Disposables.create {
                mockSession.stopRunning()
            }
        }
    }

    // 사진 촬영
    func capturePhoto() -> Single<Data> {
        return Single.create { single in
            if let mockImage = UIImage(systemName: "star")?.pngData() {
                single(.success(mockImage as Data))
            }

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

/// CameraUseCaseTests
struct CameraUseCaseTests {
    var mockRepository: MockCameraRepository!
    var cameraUseCase: CameraUseCase!

    init() async throws {
        mockRepository = MockCameraRepository()
        cameraUseCase = CameraUseCase(repository: mockRepository)
    }

    /// 카메라 프리뷰 시작 테스트
    @Test
    func testStartCameraPreviewSuccess() throws {

        // UseCase 실행
        let result = try? cameraUseCase.startCameraPreview().toBlocking().first()

        // 결과 검증
        try #require(result != nil)
        #expect(result == mockRepository.captureSession)
    }

    /// 사진 촬영 성공 테스트
    @Test
    func testTakePhotoSuccess() throws {
        // camera preview 실행
        _ = try cameraUseCase.startCameraPreview().toBlocking().first()

        try testStartCameraPreviewSuccess()

        cameraUseCase.startRunning()

        // Mock 데이터 설정
        let mockPhotoData = UIImage(systemName: "star")?.pngData()

        // UseCase 실행
        let result = try? cameraUseCase.takePhoto().toBlocking().first()

        // 결과 검증
        try #require(result != nil)
        #expect(result == mockPhotoData)
    }
}
