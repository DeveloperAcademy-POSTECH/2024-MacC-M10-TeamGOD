//
//  WifiConnectUseCaseTests.swift
//  WasapTests
//
//  Created by 김상준 on 10/9/24.
//

import Foundation
import RxSwift
import NetworkExtension
@testable import Wasap
import Testing
import RxSwift
import RxBlocking
import UIKit

class MockWifiConnectRepository: WiFiConnectRepository {
    
    func connectToWiFi(ssid: String, password: String) -> Single<WifiConnectDTO> {
        return Single<WifiConnectDTO>.create { single in
            let config = NEHotspotConfiguration(ssid: ssid,
                                                passphrase: password,
                                                isWEP: false)
            config.joinOnce = true
            
            // MARK: WIFI 연결
            NEHotspotConfigurationManager.shared.apply(config) { error in
                // MARK: 연결 실패 / 연결 성공
                let message: String
                
                if let err = error {
                    print(err)
                    message = "연결 실패: \(err.localizedDescription)"
                    // 에러 발생 시 Single.failure로 처리
                    single(.failure(err)) // 여기서 오류를 반환하여 실패로 처리
                } else {
                    message = "\(ssid) 연결 성공"
                    single(.success(WifiConnectDTO(isConnect: true, message: message))) // 성공일 경우
                }
            }
            return Disposables.create()
        }
    }
}

class MockWiFiConnectUseCase: WiFiConnectUseCase {
    let repository: WiFiConnectRepository
    
    public init(repository: WiFiConnectRepository) {
        self.repository = repository
    }
    
    public func connectToWiFi(ssid: String, password: String) -> Single<Bool> {
        return repository.connectToWiFi(ssid: ssid, password: password)
            .map { WifiConnectDTO in
            return WifiConnectDTO.isConnect
        }
    }
}


// MARK: WIFI 연결 USECASE TEST
struct WifiConnectUseCaseTests {
    var mockRepository: MockWifiConnectRepository!
    var useCase: MockWiFiConnectUseCase!
    
    init() async throws {
        mockRepository = MockWifiConnectRepository()
        useCase = MockWiFiConnectUseCase(repository: mockRepository)
    }
    
    @Test
    func testConnectToWiFiSuccess() throws {
        // UseCase 실행
        let ssid: String = "ssid"
        let pw: String = "pw"
        
        let result : Bool? = try? useCase.connectToWiFi(ssid: ssid, password: pw).toBlocking().first()

        // 결과 검증
        try #require( result == nil)
    }
    
    @Test
    func testConnectToWiFiFailure() throws {
        // UseCase 실행
        let ssid: String = "ssid"
        let pw: String = "pw"
        
        let result : Bool? = try? useCase.connectToWiFi(ssid: ssid, password: pw).toBlocking().first()
        

        // 결과 검증
        try #require( result == nil )
    }
}
