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

struct ImageAnalysisRepositoryTests {
    
    var repository: DefaultImageAnalysisRepository!
    
    init() {
        repository = DefaultImageAnalysisRepository()
    }
    
    // OCR 성공 테스트
    @Test
    func testPerformOCRSuccess() throws {
        guard let testImageData = UIImage(named: "testImageOCR")?.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        // Repository 실행
        let result = try repository.performOCR(from: testImageData).toBlocking().first()
        
        // 결과 검증
        try #require(result != nil)
        let (boundingBoxes, ssid, password) = result!
        
        try #require(!boundingBoxes.isEmpty)
        try #require(!ssid.isEmpty)
        try #require(!password.isEmpty)
    }
    
    // OCR 실패 테스트
    @Test
    func testPerformOCRError() throws {
        let invalidImageData = Data()
        
        // Repository 실행
        let result = try? repository.performOCR(from: invalidImageData).toBlocking().first()
        
        try #require(result == nil)
    }
}

