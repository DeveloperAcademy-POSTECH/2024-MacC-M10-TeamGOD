//
//  CameraViewController.swift
//  Wasap
//
//  Created by chongin on 10/7/24.
//

import UIKit
import AVFoundation
import RxSwift
import CoreLocation

public class CameraViewController: RxBaseViewController<CameraViewModel> {
    private let cameraView = CameraView()

    override init(viewModel: CameraViewModel) {
        super.init(viewModel: viewModel)
        bind(viewModel)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        self.view = cameraView

    }

    private func bind(_ viewModel: CameraViewModel) {
        viewModel.previewLayer
            .drive { [weak self] previewLayer in
                Log.debug("preview layer on VC : \(previewLayer)")
                self?.cameraView.previewLayer = previewLayer
                self?.cameraView.previewContainerView.layer.addSublayer(previewLayer)
                self?.cameraView.previewLayer?.frame = (self?.cameraView.previewContainerView.bounds)!
            }
            .disposed(by: disposeBag)

        viewModel.isZoomControlButtonHidden
            .drive { [weak self] isHidden in
                self?.cameraView.zoomControlButton.isHidden = isHidden
                self?.cameraView.zoomSliderStack.isHidden = !isHidden
            }
            .disposed(by: disposeBag)

        cameraView.zoomControlButton.rx.tap
            .bind(to: viewModel.zoomControlButtonDidTap)
            .disposed(by: disposeBag)

        cameraView.zoomSlider.rx.currentSteppedValue
            .map { CGFloat($0) }
            .bind(to: viewModel.zoomValue)
            .disposed(by: disposeBag)

        cameraView.takePhotoButton.rx.tap
            .compactMap { [weak self] _ in self?.cameraView.maskRect }
            .bind(to: viewModel.shutterButtonDidTapWithMask)
            .disposed(by: disposeBag)

        //--------

        viewModel.imageResult
            .drive { [weak self] image in
                self?.cameraView.capturedImageView.image = image
            }
            .disposed(by: disposeBag)
        //--------
    }

}
