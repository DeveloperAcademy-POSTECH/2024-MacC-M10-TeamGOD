//
//  WifiConnectRepository.swift
//  Wasap
//
//  Created by 김상준 on 10/6/24.
//

import RxSwift
import NetworkExtension
import Foundation

public protocol WiFiConnectRepository {
    func connectToWiFi(ssid: String, password: String) -> Single<WifiConnectDTO>
}

public final class DefaultWifiConnectRepository: WiFiConnectRepository {
    
    init() {
        
    }
    public func connectToWiFi(ssid: String, password: String) -> Single<WifiConnectDTO> {
        Single<WifiConnectDTO>.create { single in
            
            let config = NEHotspotConfiguration(ssid: ssid,passphrase: password,isWEP: false)
            config.joinOnce = true
            
            // 와이파이 연결 시도
            NEHotspotConfigurationManager.shared.apply(config) { error in
                if let err = error {
                    // 에러 처리
                    let message: String
                    
                    if err.localizedDescription == "already associated" {
                        message = "Already connected to \(ssid)"
                        single(.success(WifiConnectDTO(success: true, message: message)))
                    } else {
                        message = "Failed to connect: \(err.localizedDescription)"
                        single(.success(WifiConnectDTO(success: false, message: message)))
                    }
                } else {
                    // 연결 성공
                    let message = "Successfully connected to \(ssid)"
                    single(.success(WifiConnectDTO(success: true, message: message)))
                }
            }
            // Disposable 생성 및 반환
            return Disposables.create()
        }
    }
}
