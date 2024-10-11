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
    
    // MARK: Wi-Fi 연결 시도 함수
    public func connectToWiFi(ssid: String, password: String) -> Single<Bool> {
        Single<Bool>.create { single in
            let config = NEHotspotConfiguration(ssid: ssid, passphrase: password, isWEP: false)
            config.joinOnce = false
            
            // MARK: WIFI 연결 시도
            NEHotspotConfigurationManager.shared.apply(config) { error in
                if let err = error {
                    print("Connection failed: \(err.localizedDescription)")
                    single(.failure(err))
                }
                else {
                    // MARK: 다른 네트워크에 연결 되어 있는 경우, getCurrentWiFiSSID로 부터 받는 데이터가 있다.
                    
                    // MARK: 타이머 (연결 될때 까지 확인)
                    if let currentSSID = self.getCurrentWiFiSSID(), currentSSID == ssid {
                        print("Successfully connected to \(ssid)")
                        print(self.getCurrentWiFiSSID())
                        single(.success(true)) // 성공
                    }
                    // MARK: 연결 되어 있지 않은 경우, getCurrentWiFiSSID로 부터 받는 데이터가 없다.
                    else {
                        print("Failed to connect to \(ssid)")
                        single(.failure(WiFiConnectionErrors.failedToConnect(ssid)))
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
