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

    public lazy var zoomControlButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "plus.magnifyingglass"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(showZoomSliderView), for: .touchUpInside)
        return button
    }()

    private lazy var zoomSliderStack: UIStackView = {

        let minusImage = UIImageView(image: UIImage(systemName: "minus"))
        minusImage.contentMode = .scaleAspectFit
        minusImage.tintColor = .white

        let plusImage = UIImageView(image: UIImage(systemName: "plus"))
        plusImage.contentMode = .scaleAspectFit
        plusImage.tintColor = .white

        let stackView = UIStackView(arrangedSubviews: [
            minusImage,
            zoomSlider,
            plusImage,
        ])

        stackView.axis = .horizontal
        stackView.spacing = 8

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
            $0.width.height.equalTo(50)
        }

        zoomSliderStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(zoomControlButton.snp.top).offset(-16)
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(50)
        }

    }

    @objc private func showZoomSliderView() {
        zoomSlider.isHidden.toggle()
    }
}

// https://stackoverflow.com/questions/69817749/add-ticker-to-snapping-uislider
protocol CustomSliderDelegate: NSObject {
    func sliderChanged(_ newValue: Int, sender: Any)
}
extension CustomSliderDelegate {
    func sliderChanged(_ newValue: Int, sender: Any) {}
}

public final class CustomSlider: UISlider {
    let generator = UISelectionFeedbackGenerator()
    var delegate: CustomSliderDelegate?
    var stepCount: Int
    var currentStep: Int {
        valueToStep(self.value)
    }
    var currentSteppedValue: Float {
        get {
            stepToValue(currentStep)
        }
        set {
            self.setValue(newValue, animated: true)
        }
    }

    init(stepCount: Int = 50) {
        self.stepCount = stepCount
        super.init(frame: .zero)
        let thumbImage = UIGraphicsImageRenderer(size: CGSize(width: 4, height: 60)).image { context in
            UIColor.white.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 4, height: 60))
        }
        self.setThumbImage(thumbImage, for: .normal)
        self.minimumValue = 1.0
        self.maximumValue = 10.0
        self.value = 1.0
        self.tintColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var result = super.trackRect(forBounds: bounds)
        result.size.height = 0
        return result
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        // get the track rect
        let trackR: CGRect = super.trackRect(forBounds: bounds)

        // get the thumb rect at min and max values
        let minThumbR: CGRect = self.thumbRect(forBounds: bounds, trackRect: trackR, value: minimumValue)
        let maxThumbR: CGRect = self.thumbRect(forBounds: bounds, trackRect: trackR, value: maximumValue)

        // usable width is center of thumb to center of thumb at min and max values
        let usableWidth: CGFloat = maxThumbR.midX - minThumbR.midX

        // Tick Height (or use desired explicit height)
        let tickHeight: CGFloat = bounds.height

        // "gap" between tick marks
        let stepWidth: CGFloat = usableWidth / CGFloat(stepCount)

        // a reusable path
        var pth: UIBezierPath!

        // a reusable point
        var pt: CGPoint!

        // new path
        pth = UIBezierPath()

        // left end of our track rect
        pt = CGPoint(x: minThumbR.midX, y: bounds.height * 0.5)

        // top of vertical tick lines
        pt.y = (bounds.height - tickHeight) * 0.5

        // we have to draw stepCount + 1 lines
        //  so use
        //      0...stepCount
        //  not
        //      0..<stepCount

        let valueToStep = Int((Double(value - minimumValue) / Double(maximumValue - minimumValue)) * Double(stepCount))
        for i in 0...valueToStep {
            if i%5 != 0 {
                pt.y += tickHeight * 0.25
                pth.move(to: pt)
                pth.addLine(to: CGPoint(x: pt.x, y: pt.y + tickHeight * 0.5))
                pt.y -= tickHeight * 0.25
            } else {
                pth.move(to: pt)
                pth.addLine(to: CGPoint(x: pt.x, y: pt.y + tickHeight * 0.75))
            }
            pt.x += stepWidth
        }
        UIColor.white.setStroke()
        pth.stroke()

        guard valueToStep + 1 < stepCount else { return }

        pth = UIBezierPath()

        for i in valueToStep + 1...stepCount {
            if i%5 != 0 {
                pt.y += tickHeight * 0.25
                pth.move(to: pt)
                pth.addLine(to: CGPoint(x: pt.x, y: pt.y + tickHeight * 0.5))
                pt.y -= tickHeight * 0.25
            } else {
                pth.move(to: pt)
                pth.addLine(to: CGPoint(x: pt.x, y: pt.y + tickHeight * 0.75))
            }
            pt.x += stepWidth
        }
        UIColor.lightGray.setStroke()
        pth.stroke()
    }

    public override func setValue(_ value: Float, animated: Bool) {
        // don't allow value outside range of min and max values
        let newVal: Float = min(max(minimumValue, value), maximumValue)
        if self.currentStep != valueToStep(value) {
            playHapticFeedback()
        }
        super.setValue(newVal, animated: animated)
        // we need to trigger draw() when the value changes
        setNeedsDisplay()
        let steps: Float = Float(stepCount)
        let rng: Float = maximumValue - minimumValue
        // get the percentage along the track
        let pct: Float = newVal / rng
        // use that pct to get the rounded step position
        let pos: Float = round(steps * pct)
        // tell the delegate which Tick the thumb snapped to
        delegate?.sliderChanged(Int(pos), sender: self)
    }

    public override var bounds: CGRect {
        willSet {
            // we need to trigger draw() when the bounds changes
            setNeedsDisplay()
        }
    }

    private func valueToStep(_ value: Float) -> Int {
        Int((Float(value - self.minimumValue) / Float(self.maximumValue - self.minimumValue)) * Float(self.stepCount))
    }

    private func playHapticFeedback() {
        generator.selectionChanged()
    }

    private func stepToValue(_ step: Int) -> Float {
        Float(step) / Float(stepCount) * Float(maximumValue - minimumValue) + Float(minimumValue)
    }
}

import RxSwift
import RxCocoa

extension Reactive where Base: CustomSlider {
    public var currentSteppedValue: ControlProperty<Float> {
        return controlProperty(editingEvents: [.allEditingEvents, .valueChanged]) { slider in
            slider.currentSteppedValue
        } setter: { slider, value in
            slider.currentSteppedValue = value
        }
    }
}
