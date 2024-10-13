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

public protocol WiFiConnectRepository {
    func connectToWiFi(ssid: String, password: String) -> Single<Bool>
    func isWiFiConnected() -> Bool
    func getCurrentWiFiSSID() -> String?
}

public final class DefaultWiFiConnectRepository: WiFiConnectRepository {
    
    // Wi-Fi 연결 시도 함수
    public func connectToWiFi(ssid: String, password: String) -> Single<Bool> {
        Single<Bool>.create { single in
            let config = NEHotspotConfiguration(ssid: ssid, passphrase: password, isWEP: false)
            config.joinOnce = true
            
            // MARK: WIFI 연결 시도
            NEHotspotConfigurationManager.shared.apply(config) { error in
                if let err = error {
                    print("Connection failed: \(err.localizedDescription)")
                    single(.failure(err))
                } else {
                    let currentSSID = self.getCurrentWiFiSSID()
                    if currentSSID == ssid {
                        print("Successfully connected to \(ssid)")
                        single(.success(true)) // 성공
                    } else {
                        print("Failed to connect to \(ssid)")
                        print("getCurrentWiFiSSID: \(String(describing: currentSSID))")
                        single(.failure(WiFiConnectionErrors.failedToConnect(ssid)))
                    }
                    
                    /*
                     var retryCount = 0
                     
                     self.checkSSID(ssid: ssid)
                     .retry(when: { errorObservable in
                     errorObservable
                     .do(onNext: { _ in
                     retryCount += 1
                     print("Retrying SSID check (\(retryCount))")
                     })
                     .delay(.seconds(5), scheduler: MainScheduler.instance)
                     })
                     .take(10)
                     .subscribe(onNext: { success in
                     if success {
                     print("Successfully connected to \(ssid)")
                     single(.success(true)) // 성공
                     } else {
                     print("Failed to connect to \(ssid)")
                     single(.failure(WiFiConnectionErrors.failedToConnect(ssid)))
                     }
                     }, onError: { error in
                     print("SSID check failed with error: \(error)")
                     single(.failure(WiFiConnectionErrors.failedToConnect(ssid)))
                     })
                     .disposed(by: DisposeBag())
                     */
                }
            }
            return Disposables.create()
        }
    }
    
    private func checkSSID(ssid: String) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            let currentSSID = self.getCurrentWiFiSSID()
            if currentSSID == ssid {
                print("Successfully connected to \(ssid)")
                observer.onNext(true)
                observer.onCompleted()
            } else {
                print("Failed to connect to \(ssid)")
                print("getCurrentWiFiSSID: \(String(describing: currentSSID))")
                observer.onNext(false)
                observer.onCompleted()
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
