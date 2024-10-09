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
    
    public func connectToWiFi(ssid: String, password: String) -> Single<WifiConnectDTO> {
        
        Single<WifiConnectDTO>.create { single in
            
            let config = NEHotspotConfiguration(ssid: ssid,passphrase: password,isWEP: false)
            config.joinOnce = true
            
            // MARK: WIFI 연결
            NEHotspotConfigurationManager.shared.apply(config) { error in
                // MARK: 연결 실패 / 연결 성공
                let message: String
                if let err = error {
                    message = "Failed to connect: \(err.localizedDescription)"
                    single(
                        // failure 일 경우 크래시 발생
                        .success(WifiConnectDTO(isConnect: false, message: message)))
                } else {
                    message = "Successfully connected to \(ssid)"
                    single(
                        .success(WifiConnectDTO(isConnect: true, message: message)))
                }
            }
            // Disposable 생성 및 반환
            // 메서드 반환의 경우 disposedBag 보다 create하는 것이 맞다.
            return Disposables.create()
        }
    }
}
