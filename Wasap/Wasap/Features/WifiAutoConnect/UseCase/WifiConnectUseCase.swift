//
//  WifiConnectUseCase.swift
//  Wasap
//
//  Created by 김상준 on 10/6/24.
//

import RxSwift
import Foundation

// MARK: 와이파이 연결 Use Case 프로토콜
public protocol WiFiConnectUseCase {
    func connectToWiFi(ssid: String, password: String) -> Single<Bool>
}

// MARK: 와이파이 연결 Use Case 기본 구현체
public class DefaultWiFiConnectUseCase: WiFiConnectUseCase {
    let wifiConnectRepository: WiFiConnectRepository
    
    public init(wifiConnectRepository: WiFiConnectRepository) {
        self.wifiConnectRepository = wifiConnectRepository
    }
    
    public func connectToWiFi(ssid: String, password: String) -> Single<Bool> {
        wifiConnectRepository.connectToWiFi(ssid: ssid, password: password)
        // flatamap으로 비동기 처리하는 것이 맞을까?
            .map { WifiConnectDTO in
                return WifiConnectDTO.isConnect
            }
            .catch { error in
                return .just(false)
            }
    }
}
