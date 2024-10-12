//
//  ScanViewModel.swift
//  Wasap
//
//  Created by Chang Jonghyeon on 10/10/24.
//

import RxSwift
import RxCocoa
import UIKit

public class ScanViewModel: BaseViewModel {
    // MARK: - Coordinator
    private weak var coordinatorController: ScanCoordinatorController?
    
    // MARK: - Input
    // public let analyzeImageButtonTapped = PublishRelay<Void>()
    // public let image: BehaviorRelay<UIImage>
    
    // MARK: - Output
    // public var boundingBoxes: Driver<[(CGRect, CGColor)]>
    public var ssidText: Driver<String>
    public var passwordText: Driver<String>
    public var updatedImage: Driver<UIImage>
    
    public init(imageAnalysisUseCase: ImageAnalysisUseCase, coordinatorController: ScanCoordinatorController, previewImage: UIImage) {
        // let boundingBoxesRelay = BehaviorRelay<[(CGRect, CGColor)]>(value: [])
        // self.boundingBoxes = boundingBoxesRelay.asDriver(onErrorJustReturn: [])
        
        let ssidRelay = BehaviorRelay<String>(value: "")
        self.ssidText = ssidRelay.asDriver(onErrorJustReturn: "")
        let passwordRelay = BehaviorRelay<String>(value: "")
        self.passwordText = passwordRelay.asDriver(onErrorJustReturn: "")
        
        let updatedImageRelay = BehaviorRelay<UIImage?>(value: nil)
        self.updatedImage = updatedImageRelay.asDriver(onErrorJustReturn: nil).compactMap { $0 }
        
        self.coordinatorController = coordinatorController
        super.init()
        
        self.viewDidLoad
            .flatMapLatest { _ in
                return imageAnalysisUseCase.performOCR(on: previewImage)
            }
            .subscribe(onNext: { boundingBoxes, ssid, password in
                // oundingBoxesRelay.accept(boundingBoxes)
                ssidRelay.accept(ssid)
                passwordRelay.accept(password)
                updatedImageRelay.accept(self.drawBoundingBoxes(boundingBoxes, on: previewImage))
            }, onError: { error in
                print("OCR Error: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    // bounding box를 이미지 위에 그리는 함수
    private func drawBoundingBoxes(_ boxes: [(CGRect, CGColor)], on image: UIImage) -> UIImage? {
        let imageSize = image.size
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let context = UIGraphicsGetCurrentContext()

        image.draw(at: .zero)

        for (box, color) in boxes {
            let rect = CGRect(
                x: box.origin.x * imageSize.width,
                y: (1 - box.origin.y - box.height) * imageSize.height,
                width: box.width * imageSize.width,
                height: box.height * imageSize.height
            )
            context?.setStrokeColor(color)
            context?.setLineWidth(2.0)
            context?.stroke(rect)
        }

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
