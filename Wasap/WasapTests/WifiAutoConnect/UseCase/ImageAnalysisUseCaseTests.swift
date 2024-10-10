//
//  ImageAnalysisUseCaseTests.swift
//  WasapTests
//
//  Created by Chang Jonghyeon on 10/9/24.
//

import RxSwift
import RxBlocking
import Testing
import UIKit
@testable import Wasap

class ImageAnalysisUseCaseTests {
    var repository: DefaultImageAnalysisRepository!
    var useCase: DefaultImageAnalysisUseCase
    let bundle: Bundle
    
    init() {
        repository = DefaultImageAnalysisRepository()
        useCase = DefaultImageAnalysisUseCase(imageAnalysisRepository: repository)
        bundle = Bundle(for: type(of: self))
    }
    
    // OCR 성공 테스트
    @Test
    func testPerformOCRSuccess() throws {
        guard let image = UIImage(named: "OCRTestImage", in: bundle, compatibleWith: nil) else {
            Issue.record("이미지 불러올 수 없음")
            return
        }
        
        // UseCase 실행
        let result = try useCase.performOCR(on: image).toBlocking().first()
        
        // 결과 검증
        try #require(result != nil)
        let (boundingBoxes, ssid, password) = result!
        
        try #require(!boundingBoxes.isEmpty)
        #expect(ssid == "Tarrtarr")
        #expect(password == "12345678")
    }
    
    // OCR 실패 테스트
    @Test
    func testPerformOCRError() throws {
        guard let image = UIImage(named: "OCRTestImage2", in: bundle, compatibleWith: nil) else {
            Issue.record("이미지 불러올 수 없음")
            return
        }
        
        // UseCase 실행
        let result = try useCase.performOCR(on: image).toBlocking().first()
        
        // 결과 검증
        let (boundingBoxes, ssid, password) = result!
        
        try #require(!boundingBoxes.isEmpty)
        #expect(ssid == "")
        #expect(password == "")
    }
}

