//
//  CameraViewController.swift
//  Wasap
//
//  Created by chongin on 10/7/24.
//

import UIKit
import AVFoundation
import RxSwift

class CameraViewController: UIViewController {
    private let cameraUseCase: CameraUseCase
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private let disposeBag = DisposeBag()

    private var previewContainerView: UIView!  // 프리뷰 레이어를 담을 뷰
    private var capturedImageView: UIImageView!
    private var takePhotoButton: UIButton!

    init(cameraUseCase: CameraUseCase) {
        self.cameraUseCase = cameraUseCase
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPreviewContainerView()
        setupCapturedImageView()
        setupTakePhotoButton()

        cameraUseCase.configureCamera()
            .subscribe(onSuccess: { [weak self] _ in
                print("Configure Camera Success!")
                self?.setupPreviewLayer()
            }, onFailure: { error in
                print("Error starting camera preview: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = previewContainerView.bounds
    }

    private func setupPreviewContainerView() {
        previewContainerView = UIView()
        previewContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(previewContainerView)

        NSLayoutConstraint.activate([
            previewContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            previewContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            previewContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupPreviewLayer() {
        let preview = cameraUseCase.getCapturePreviewLayer()
        preview.subscribe(onSuccess: { [weak self] previewLayer in
            self?.previewContainerView.layer.addSublayer(previewLayer)
            self?.previewLayer = previewLayer
        }, onFailure: { error in
            print(error)
        })
        .disposed(by: disposeBag)

        cameraUseCase.startRunning()
    }

    private func setupCapturedImageView() {
        capturedImageView = UIImageView()
        capturedImageView.contentMode = .scaleAspectFit
        capturedImageView.isHidden = true
        capturedImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(capturedImageView)

        NSLayoutConstraint.activate([
            capturedImageView.topAnchor.constraint(equalTo: view.topAnchor),
            capturedImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            capturedImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            capturedImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupTakePhotoButton() {
        takePhotoButton = UIButton(type: .system)
        takePhotoButton.setTitle("Take Photo", for: .normal)
        takePhotoButton.backgroundColor = .systemBlue
        takePhotoButton.setTitleColor(.white, for: .normal)
        takePhotoButton.layer.cornerRadius = 8
        takePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        takePhotoButton.addTarget(self, action: #selector(didPressTakePhoto), for: .touchUpInside)
        view.addSubview(takePhotoButton)

        NSLayoutConstraint.activate([
            takePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            takePhotoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            takePhotoButton.widthAnchor.constraint(equalToConstant: 100),
            takePhotoButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func didPressTakePhoto() {
        cameraUseCase.takePhoto()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] image in
                guard let self = self else { return }
                self.displayCapturedPhoto(image)
                print("Photo captured successfully")
            }, onFailure: { error in
                print("Error capturing photo: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    private func displayCapturedPhoto(_ image: UIImage) {
        capturedImageView.image = image
        capturedImageView.isHidden = false
        previewContainerView.isHidden = true
        takePhotoButton.isHidden = true
    }
}

