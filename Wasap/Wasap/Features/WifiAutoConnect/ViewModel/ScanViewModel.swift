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

    // MARK: - UseCase
    private let imageAnalysisUseCase: ImageAnalysisUseCase

    // MARK: - Input
    
    // MARK: - Output
    public var updatedImage: Driver<UIImage>

    // MARK: - Properties
    private var ocrResult: Observable<([(CGRect, CGColor)], String, String)>

    public init(imageAnalysisUseCase: ImageAnalysisUseCase, coordinatorController: ScanCoordinatorController, previewImage: UIImage) {
        self.imageAnalysisUseCase = imageAnalysisUseCase

        let ocrResultRelay = BehaviorRelay<([(CGRect, CGColor)], String, String)>(value: ([], "", ""))
        self.ocrResult = ocrResultRelay.asObservable().share()

        let updatedImageRelay = BehaviorRelay<UIImage?>(value: nil)
        self.updatedImage = updatedImageRelay.asDriver(onErrorJustReturn: nil).compactMap { $0 }
        
        self.coordinatorController = coordinatorController
        super.init()
        
        viewDidLoad
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                imageAnalysisUseCase.performOCR(on: previewImage)
            }
            .subscribe {
                Log.debug("OCR 성공")
                ocrResultRelay.accept($0)
            } onError: { error in
                Log.error("OCR 중 에러 발생: \(error.localizedDescription)")
            }
            .disposed(by: disposeBag)

        ocrResult
            .subscribe { boundingBoxes, _, _ in
                updatedImageRelay.accept(self.drawBoundingBoxes(boundingBoxes, on: previewImage))
            }
            .disposed(by: disposeBag)

        ocrResult
            .subscribe { _, ssid, password in
                print("OCR 후 SSID: \(ssid), Password: \(password)")
                self.coordinatorController?.performTransition(to: .connecting( imageData: previewImage,ssid: ssid, password: password))
            }
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
