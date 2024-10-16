//
//  ImageAnalysisErrors.swift
//  Wasap
//
//  Created by Chang Jonghyeon on 10/17/24.
//

enum ImageAnalysisError: Error {
    case invalidImage
    case ocrFailed(String)
    case boxDrawingFailed

    var localizedDescription: String {
        switch self {
        case .invalidImage:
            return "Invalid image"
        case .ocrFailed(let message):
            return "OCR failed: \(message)"
        case .boxDrawingFailed:
            return "Box drawing failed"
        }
    }
}
