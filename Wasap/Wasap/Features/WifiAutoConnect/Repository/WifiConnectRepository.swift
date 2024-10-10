//
//  WifiConnectRepository.swift
//  Wasap
//
//  Created by 김상준 on 10/6/24.
//

import RxSwift
import NetworkExtension
import SystemConfiguration.CaptiveNetwork
import Foundation

protocol WiFiConnectRepository {
    func connectToWiFi(ssid: String, password: String) -> Single<Bool>
    func isWiFiConnected() -> Bool
    func getCurrentWiFiSSID() -> String?
}

public final class DefaultWifiConnectRepository: WiFiConnectRepository {
    
    // Wi-Fi 연결 시도 함수
    public func connectToWiFi(ssid: String, password: String) -> Single<Bool> {
        Single<Bool>.create { single in
            let config = NEHotspotConfiguration(ssid: ssid, passphrase: password, isWEP: false)
            config.joinOnce = true
            
            // MARK: WIFI 연결 시도
            NEHotspotConfigurationManager.shared.apply(config) { error in
                if let error = error {
                    print("Connection failed: \(error.localizedDescription)")
                    single(.failure(error))
                } else {
                    if self.isWiFiConnected(), let currentSSID = self.getCurrentWiFiSSID(), currentSSID == ssid {
                        print("Successfully connected to \(ssid)")
                        single(.success(true))
                    } else {
                        print("Failed to connect to \(ssid)")
                        single(.success(false))
                    }
                }
            }
            return Disposables.create()
        }
    }

    // 현재 Wi-Fi 연결 상태를 확인하는 함수
    public func isWiFiConnected() -> Bool {
        return getCurrentWiFiSSID() != nil
    }

    // 현재 연결된 Wi-Fi 네트워크의 SSID를 반환하는 함수
    public func getCurrentWiFiSSID() -> String? {
        var ssid: String?
        
        if let interfaces = CNCopySupportedInterfaces() as? [String] {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
}
