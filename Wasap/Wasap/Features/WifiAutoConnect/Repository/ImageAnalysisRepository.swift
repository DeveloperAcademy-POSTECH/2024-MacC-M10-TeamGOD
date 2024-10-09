//
//  ImageAnalysisRepository.swift
//  Wasap
//
//  Created by Chang Jonghyeon on 10/6/24.
//

import RxSwift
import Vision

public protocol ImageAnalysisRepository {
    func performOCR(from imageData: Data) -> Single<([(CGRect, CGColor)], String, String)>
}

public class DefaultImageAnalysisRepository: ImageAnalysisRepository {
    public init() {}
    
    let idStrings: Set<String> = ["ID", "Id", "iD", "id", "WIFI", "Wifi", "WiFi", "wifi", "Wi-Fi", "Network", "NETWORK", "network", "ssid", "SSID", "와이파이", "네트워크", "I.D"]
    let pwStrings: Set<String> = ["PW", "Pw", "pW", "pw", "pass", "Pass", "PASS", "password", "Password", "PASSWORD", "패스워드", "암호", "P.W"]
    
    var ssidText: String = ""
    var passwordText: String = ""
    var boundingBoxes: [(CGRect, CGColor)] = []
    
    public func performOCR(from imageData: Data) -> Single<([(CGRect, CGColor)], String, String)> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.failure(ImageAnalysisError.ocrFailed("Self not found")))
                return Disposables.create()
            }
            
            guard let cgImage = self.convertDataToCGImage(imageData) else {
                single(.failure(ImageAnalysisError.invalidImage))
                return Disposables.create()
            }
            
            let orientation = self.extractOrientation(from: imageData)
            
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: orientation, options: [:])
            
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    single(.failure(ImageAnalysisError.ocrFailed(error.localizedDescription)))
                    return
                }
                
                guard let results = request.results as? [VNRecognizedTextObservation] else {
                    single(.failure(ImageAnalysisError.ocrFailed("No results found")))
                    return
                }
                
                var boxes: [(CGRect, String)] = []
                var idBoxes: [CGRect] = []
                var pwBoxes: [CGRect] = []
                
                for observation in results {
                    if let topCandidate = observation.topCandidates(1).first {
                        let originalString = topCandidate.string
                        let boundingBox = observation.boundingBox
                        
                        // 콜론(:) 제거
                        let cleanedString = originalString.replacingOccurrences(of: "[:\\-]", with: "", options: .regularExpression)
                        
                        // 텍스트가 "ID" 또는 "PW"로 시작하는지 확인
                        let components = cleanedString.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
                        guard let firstWord = components.first.map(String.init) else { continue }
                        
                        if self.idStrings.contains(firstWord) {
                            // "ID" 부분을 분리하고 나머지 텍스트와 나눔
                            let idText = firstWord
                            let remainingText = components.count > 1 ? String(components[1]) : ""
                            
                            // "ID" 부분에 대한 Bounding Box 분리
                            let idBox = boundingBox
                            let remainingBox = self.splitBoundingBox(originalBox: boundingBox, splitFactor: 0.3)
                            
                            idBoxes.append(idBox)
                            boxes.append((idBox, "ID"))
                            
                            if !remainingText.isEmpty {
                                boxes.append((remainingBox, remainingText))
                            }
                            
                            print("원본텍스트:\(originalString), 분리된텍스트:'\(idText)' + '\(remainingText)'")
                            
                        } else if self.pwStrings.contains(firstWord) {
                            // "PW" 부분을 분리하고 나머지 텍스트와 나눔
                            let pwText = firstWord
                            let remainingText = components.count > 1 ? String(components[1]) : ""
                            
                            // "PW" 부분에 대한 Bounding Box 분리
                            let pwBox = boundingBox
                            let remainingBox = self.splitBoundingBox(originalBox: boundingBox, splitFactor: 0.3)
                            
                            pwBoxes.append(pwBox)
                            boxes.append((pwBox, "PW"))
                            
                            if !remainingText.isEmpty {
                                boxes.append((remainingBox, remainingText))
                            }
                            
                            print("원본텍스트:\(originalString), 분리된텍스트:'\(pwText)' + '\(remainingText)'")
                            
                        } else {
                            boxes.append((boundingBox, originalString))
                            print("원본텍스트:\(originalString), 기타텍스트:\(cleanedString)")
                        }
                    }
                }
                
                var finalBoxes: [(CGRect, CGColor)] = boxes.map { ($0.0, CGColor(red: 0, green: 0, blue: 0, alpha: 1)) }
                
                // "ID"에 가장 가까운 Bounding Box(SSID 값, 보라색) 탐색 - PW는 제외
                for idBox in idBoxes {
                    if let closestBox = self.closestBoundingBox(from: idBox, in: boxes.filter { $0.1 != "ID" && $0.1 != "PW" }),
                       let index = boxes.firstIndex(where: { $0.0 == closestBox.0 }) {
                        finalBoxes[index].1 = CGColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)
                        
                        self.ssidText = closestBox.1.replacingOccurrences(of: " ", with: "")
                        print("보라색박스(SSID 값 추정):\(self.ssidText)")
                    }
                }
                
                // "PW"에 가장 가까운 Bounding Box(Password 값, 연두색) 탐색 - ID와 SSID value 박스는 제외
                for pwBox in pwBoxes {
                    if let closestBox = self.closestBoundingBox(from: pwBox, in: boxes.filter { box in
                        box.1 != "ID" && box.1 != "PW" && finalBoxes.first(where: { finalBox in box.0 == finalBox.0 && finalBox.1 == CGColor(red: 0.5, green: 0, blue: 0.5, alpha: 1) }) == nil }),
                       let index = boxes.firstIndex(where: { $0.0 == closestBox.0 }) {
                        finalBoxes[index].1 = CGColor(red: 0, green: 1, blue: 0, alpha: 1)
                        
                        self.passwordText = closestBox.1.replacingOccurrences(of: " ", with: "")
                        print("연두색박스(Password 값 추정):\(self.passwordText)")
                    }
                }
                
                // "ID"는 노란색박스, "PW"는 파란색박스로 지정
                for (index, box) in boxes.enumerated() {
                    if box.1 == "ID" {
                        finalBoxes[index].1 = CGColor(red: 1, green: 1, blue: 0, alpha: 1)
                        print("노란색박스(ID 키):\(box.1)")
                    } else if box.1 == "PW" {
                        finalBoxes[index].1 = CGColor(red: 0, green: 0, blue: 1, alpha: 1)
                        print("파란색박스(PW 키):\(box.1)")
                    }
                }
                
                DispatchQueue.main.async {
                    self.boundingBoxes.append(contentsOf: finalBoxes)
                    
                    single(.success((self.boundingBoxes, self.ssidText, self.passwordText)))
                }
            }
            
            request.recognitionLanguages = ["en"]
            request.usesLanguageCorrection = true
            
            do {
                try requestHandler.perform([request])
            } catch {
                single(.failure(ImageAnalysisError.ocrFailed("Failed to perform OCR: \(error.localizedDescription)")))
            }
            
            return Disposables.create()
        }
    }
    
    // 이미지 Data 타입 -> CGImage 타입 변환
    private func convertDataToCGImage(_ data: Data) -> CGImage? {
        guard let dataProvider = CGDataProvider(data: data as CFData) else { return nil }
        return CGImage(jpegDataProviderSource: dataProvider, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
    }
    
    // 이미지 Data타입의 orientation 정보 추출
    private func extractOrientation(from imageData: Data) -> CGImagePropertyOrientation {
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            return .up
        }
        
        let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as Dictionary?
        if let orientationValue = properties?[kCGImagePropertyOrientation] as? UInt32 {
            return CGImagePropertyOrientation(rawValue: orientationValue) ?? .up
        }
        return .up
    }
    
    private func splitBoundingBox(originalBox: CGRect, splitFactor: CGFloat) -> CGRect {
        let newWidth = originalBox.width * (1 - splitFactor)
        let newX = originalBox.minX + (originalBox.width * splitFactor)
        return CGRect(x: newX, y: originalBox.minY, width: newWidth, height: originalBox.height)
    }
    
    private func closestBoundingBox(from sourceBox: CGRect, in boxes: [(CGRect, String)]) -> (CGRect, String)? {
        return boxes.min { distanceBetweenEdges($0.0, sourceBox) < distanceBetweenEdges($1.0, sourceBox) }
    }
    
    private func distanceBetweenEdges(_ rect1: CGRect, _ rect2: CGRect) -> CGFloat {
        // 각 사각형의 테두리 좌표 (X: 좌우, Y: 상하)
        let minX1 = rect1.minX
        let maxX1 = rect1.maxX
        let minY1 = rect1.minY
        let maxY1 = rect1.maxY
        
        let minX2 = rect2.minX
        let maxX2 = rect2.maxX
        let minY2 = rect2.minY
        let maxY2 = rect2.maxY
        
        // 두 사각형의 X축 방향 최단거리
        let dx: CGFloat
        if maxX1 < minX2 {
            dx = minX2 - maxX1
        } else if maxX2 < minX1 {
            dx = minX1 - maxX2
        } else {
            dx = 0
        }
        
        // 두 사각형의 Y축 방향 최단거리
        let dy: CGFloat
        if maxY1 < minY2 {
            dy = minY2 - maxY1
        } else if maxY2 < minY1 {
            dy = minY1 - maxY2
        } else {
            dy = 0
        }
        
        // 두 사각형의 대략적인 간격
        return sqrt(dx * dx + dy * dy)
    }
}

public enum ImageAnalysisError: Error {
    case invalidImage
    case ocrFailed(String)
}
