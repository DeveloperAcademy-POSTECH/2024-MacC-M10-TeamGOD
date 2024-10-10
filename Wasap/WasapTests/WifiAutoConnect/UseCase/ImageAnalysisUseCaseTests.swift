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

struct ImageAnalysisUseCaseTests {
    var repository: DefaultImageAnalysisRepository!
    var useCase: DefaultImageAnalysisUseCase
    
    init() {
        repository = DefaultImageAnalysisRepository()
        useCase = DefaultImageAnalysisUseCase(imageAnalysisRepository: repository)
    }
    
    // OCR 성공 테스트
    @Test
    func testPerformOCRSuccess() throws {
        guard let image = UIImage(named: "OCRTestImage") else {
            return
        }
        
        // UseCase 실행
        let result = try useCase.performOCR(on: image).toBlocking().first()
        
        // 결과 검증
        try #require(result != nil)
        let (boundingBoxes, ssid, password) = result!
        
        try #require(!boundingBoxes.isEmpty)
        try #require(ssid == "Tarrtarr")
        try #require(password == "12345678")
    }
    
    // OCR 실패 테스트
    @Test
    func testPerformOCRError() throws {
        guard let image = UIImage(named: "OCRTestImage2") else {
            return
        }
        
        // UseCase 실행
        let result = try useCase.performOCR(on: image).toBlocking().first()
        
        // 결과 검증
        let (boundingBoxes, ssid, password) = result!
        
        try #require(!boundingBoxes.isEmpty)
        try #require(ssid == "")
        try #require(password == "")
    }
}

