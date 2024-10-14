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
    private var superViewWidth: CGFloat {
        self.frame.size.width
    }
    private var superViewHeight: CGFloat {
        self.frame.size.height
    }
    private var maskRect: CGRect {
        CGRect(origin: CGPoint(x: superViewWidth * 0.1, y: superViewHeight * 0.35), size: CGSize(width: superViewWidth * 0.8, height: superViewHeight * 0.3))
    }
    public lazy var previewContainerView: UIView = {
        UIView()
    }()
    private lazy var capturedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    private lazy var takePhotoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "inset.filled.circle"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.contentMode = .scaleAspectFit
        return button
    }()

    private lazy var opaqueBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()

        path.addRects([
            CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: superViewWidth, height: superViewHeight)),
            maskRect
        ])
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd

        view.layer.mask = maskLayer

        let borderLayer = CAShapeLayer()
        let borderPath = UIBezierPath(rect: maskRect)
        borderLayer.path = borderPath.cgPath
        borderLayer.strokeColor = UIColor.cameraFrameGreen.cgColor
        borderLayer.lineWidth = 6.0
        borderLayer.fillColor = UIColor.clear.cgColor

        view.layer.addSublayer(borderLayer)

        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = previewContainerView.bounds
    }

    func setViewHierarchy() {
        self.addSubViews(previewContainerView, opaqueBackgroundView, capturedImageView, takePhotoButton)
    }

    func setConstraints() {
        previewContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        opaqueBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        capturedImageView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }

        takePhotoButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
            $0.width.height.equalTo(85)
        }

    }
}
