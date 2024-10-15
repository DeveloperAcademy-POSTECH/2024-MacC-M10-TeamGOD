//
//  CameraView.swift
//  Wasap
//
//  Created by chongin on 10/10/24.
//

import UIKit
import SnapKit
import AVFoundation

enum Dimension {
    enum Mask { // Mask 배율
        static let leftPadding: CGFloat = 0.1
        static let topPadding: CGFloat = 0.35
        static let width: CGFloat = 0.8
        static let height: CGFloat = 0.3
    }
}

final class CameraView: BaseView {
    var previewLayer: AVCaptureVideoPreviewLayer?
    private var superViewWidth: CGFloat {
        self.frame.size.width
    }

    private var superViewHeight: CGFloat {
        self.frame.size.height
    }

    public var maskRect: CGRect {
        CGRect(origin: CGPoint(x: superViewWidth * Dimension.Mask.leftPadding, y: superViewHeight * Dimension.Mask.topPadding), size: CGSize(width: superViewWidth * Dimension.Mask.width, height: superViewHeight * Dimension.Mask.height))
    }

    public lazy var previewContainerView: UIView = {
        UIView()
    }()

    // ----------
    public lazy var capturedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true;
        imageView.contentMode = .scaleAspectFit;
        imageView.isHidden = false
        return imageView
    }()
    // ----------

    public lazy var takePhotoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "inset.filled.circle"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.contentMode = .scaleAspectFit
        return button
    }()

    public lazy var zoomControlButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "plus.magnifyingglass"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        return button
    }()

    public lazy var zoomSliderStack: UIStackView = {
        let minusImage = UIImageView(image: UIImage(systemName: "minus"))
        minusImage.contentMode = .scaleAspectFit
        minusImage.sizeToFit()
        minusImage.tintColor = .white

        let plusImage = UIImageView(image: UIImage(systemName: "plus"))
        plusImage.contentMode = .scaleAspectFit
        plusImage.sizeToFit()
        plusImage.tintColor = .white

        let stackView = UIStackView(arrangedSubviews: [
            minusImage,
            zoomSlider,
            plusImage,
        ])

        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.backgroundColor = .cameraZoomDisabled
        stackView.layer.cornerRadius = 16
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true

        return stackView
    }()

    public lazy var zoomSlider: CustomSlider = {
        let slider = CustomSlider()
        return slider
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
        self.addSubViews(previewContainerView, opaqueBackgroundView, capturedImageView, takePhotoButton, zoomControlButton, zoomSliderStack)
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

        zoomControlButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(takePhotoButton.snp.top).offset(-16)
            $0.width.height.equalTo(46)
        }

        zoomSliderStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(takePhotoButton.snp.top).offset(-32)
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(84)
        }
    }
}
