//
//  ImageAnalysisUseCase.swift
//  Wasap
//
//  Created by Chang Jonghyeon on 10/6/24.
//

import RxSwift
import UIKit

public protocol ImageAnalysisUseCase {
    func performOCR(on image: UIImage) -> Single<([(CGRect, CGColor)], String, String)>
}

public class DefaultImageAnalysisUseCase: ImageAnalysisUseCase {
    let imageAnalysisRepository: ImageAnalysisRepository
    
    public init(imageAnalysisRepository: ImageAnalysisRepository) {
        self.imageAnalysisRepository = imageAnalysisRepository
    }
    
    public func performOCR(on image: UIImage) -> Single<([(CGRect, CGColor)], String, String)> {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return Single.error(ImageAnalysisError.invalidImage)
        }
        
        return imageAnalysisRepository.performOCR(from: imageData)
            .catch { error in
                print("OCR Error: \(error.localizedDescription)")
                return .just(([], "", ""))
            }
    }
}
