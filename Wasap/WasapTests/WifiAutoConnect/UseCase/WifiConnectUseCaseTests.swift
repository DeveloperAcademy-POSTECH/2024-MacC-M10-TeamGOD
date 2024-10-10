//
//  WifiConnectUseCaseTests.swift
//  WasapTests
//
//  Created by 김상준 on 10/10/24.
//

import Foundation
import RxSwift
import NetworkExtension
@testable import Wasap
import Testing
import RxSwift
import RxBlocking
import SystemConfiguration.CaptiveNetwork
import UIKit

class MockWifiConnectRepository: WiFiConnectRepository {
    
    // 현재 Wi-Fi 연결 상태를 확인하는 함수
    func isWiFiConnected() -> Bool {
        return getCurrentWiFiSSID() != nil
    }
    
    // 현재 연결된 Wi-Fi 네트워크의 SSID를 반환하는 함수
    func getCurrentWiFiSSID() -> String? {
        var ssid: String?
        
        // CNCopySupportedInterfaces()를 통해 사용 가능한 네트워크 인터페이스 목록을 가져옴
        if let interfaces = CNCopySupportedInterfaces() as? [String] {
            for interface in interfaces {
                // 각 인터페이스에 대해 현재 연결된 네트워크 정보를 가져옴
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as CFString) as NSDictionary? {
                    // 네트워크 정보에서 SSID(네트워크 이름)를 가져옴
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break // 첫 번째로 발견한 SSID를 반환하기 위해 반복 종료
                }
            }
        }
        // 연결된 SSID를 반환하거나, 없으면 nil을 반환
        return ssid
    }
    
    
    // Wi-Fi 연결하는 함수
    func connectToWiFi(ssid: String, password: String) -> Single<Bool> {
        Single<Bool>.create { single in
            let config = NEHotspotConfiguration(ssid: ssid, passphrase: password, isWEP: false)
            config.joinOnce = true
            
            // MARK: WIFI 연결 시도
            NEHotspotConfigurationManager.shared.apply(config) { error in
                if let err = error {
                    print("Connection failed: \(err.localizedDescription)")
                    single(.failure(err))
                } else {
                    if let currentSSID = self.getCurrentWiFiSSID(), currentSSID == ssid {
                        print("Successfully connected to \(ssid)")
                        single(.success(true)) // 성공
                    } else {
                        print("Failed to connect to \(ssid)")
                        single(.failure(WiFiConnectionErrors.failedToConnect(ssid)))
                    }
                }
            }
            return Disposables.create()
        }
    }
}

class MockWiFiConnectUseCase: WiFiConnectUseCase {
    let repository: WiFiConnectRepository
    
    init(repository: WiFiConnectRepository) {
        self.repository = repository
    }
    
    func connectToWiFi(ssid: String, password: String) -> Single<Bool> {
        return repository.connectToWiFi(ssid: ssid, password: password)
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
    
    // 와이파이 자동 연결
    @Test
    func testAutoConnectToWiFiSuccess() throws {
        
        // 옳바른 ssid, pw 일 경우
        let ssid: String = "ssid"
        let pw: String = "pw"
        
        let result : Bool? = try? useCase.connectToWiFi(ssid: ssid, password: pw).toBlocking().first()
        
        // 결과 검증
        try #require( result == true)
    }
    
    @Test
    func testAutoConnectToWiFiFailure() throws {
        
        // 틀린 ssid, pw 일 경우
        let ssid: String = "ssid"
        let pw: String = "pw"
        
        let result : Bool? = try? useCase.connectToWiFi(ssid: ssid, password: pw).toBlocking().first()
        
        // 결과 검증
        try #require( result == false)
    }
    
    // 연결된 네트워크 SSID를 반환 . nil 이 아닌 경우 네트워크 접속 확인
    @Test
    func getCurrentWiFiSSIDSuccess() throws {
        let ssid = mockRepository.getCurrentWiFiSSID()
        // 결과 검증
        try #require( ssid != nil )
    }
}
