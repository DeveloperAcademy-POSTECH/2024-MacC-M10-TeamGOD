//
//  CameraView.swift
//  Wasap
//
//  Created by chongin on 10/10/24.
//

import UIKit
import SnapKit
import AVFoundation

final class CameraView: BaseView {
    var previewLayer: AVCaptureVideoPreviewLayer?
    lazy var previewContainerView: UIView = {
        UIView()
    }()
    private lazy var capturedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    private lazy var takePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Take Photo", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        return button
    }()

    override func layoutSubviews() {
        previewLayer?.frame = previewContainerView.bounds
        super.layoutSubviews()
    }

    func setViewHierarchy() {
        self.addSubViews(previewContainerView, capturedImageView, takePhotoButton)
    }

    func setConstraints() {
        previewContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        capturedImageView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }

        takePhotoButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
        }
    }
}
