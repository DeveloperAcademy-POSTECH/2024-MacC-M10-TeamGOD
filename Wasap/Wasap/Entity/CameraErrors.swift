//
//  CameraErrors.swift
//  Wasap
//
//  Created by chongin on 10/8/24.
//

enum CameraErrors: Error {
    case notAuthorized
    case cameraNotFound
    case unknown
    case captureDeviceError
    case imageOutputNotAvailable
    case photoProcessingError
    case imageConvertError
    case previewLayerError

    var localizedDescription: String {
        switch self {
        case .notAuthorized:
            return "Not authorized"
        case .cameraNotFound:
            return "Camera not found"
        case .unknown:
            return "Unknown error"
        case .captureDeviceError:
            return "Capture device error"
        case .imageOutputNotAvailable:
            return "Image output not available"
        case .photoProcessingError:
            return "Photo processing error"
        case .imageConvertError:
            return "Image convert error"
        case .previewLayerError:
            return "Preview layer error"
        }
    }
}
