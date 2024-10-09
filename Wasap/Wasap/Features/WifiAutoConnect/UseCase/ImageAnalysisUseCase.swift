//
//  ImageAnalysisUseCase.swift
//  Wasap
//
//  Created by Chang Jonghyeon on 10/6/24.
//

import RxSwift
import UIKit

public protocol ImageAnalysisUseCase {
    func performOCR(on image: UIImage) -> Single<([(CGRect, UIColor)], String, String)>
}

public class DefaultImageAnalysisUseCase: ImageAnalysisUseCase {
    let imageAnalysisRepository: ImageAnalysisRepository
    
    public init(imageAnalysisRepository: ImageAnalysisRepository) {
        self.imageAnalysisRepository = imageAnalysisRepository
    }
    
    public func performOCR(on image: UIImage) -> Single<([(CGRect, UIColor)], String, String)> {
        return imageAnalysisRepository.performOCR(from: image)
            .catch { error in
                print("OCR Error: \(error.localizedDescription)")
                return .just(([], "", ""))
            }
    }
}
