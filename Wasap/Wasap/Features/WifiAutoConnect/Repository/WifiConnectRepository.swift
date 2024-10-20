//
//  WifiConnectRepository.swift
//  Wasap
//
//  Created by 김상준 on 10/6/24.
//

import RxSwift
import NetworkExtension
import CoreLocation

public protocol WiFiConnectRepository {
    // 와이파이 연결을 시도합니다. 그리고 성공 여부를 반환합니다.
    func connectToWiFi(ssid: String, password: String) -> Single<Bool>
    // 와이파이에 연결된 상태인지 확인합니다.
    func isWiFiConnectedcheck() -> Single<Bool>
    // 연결된 와이파이 SSID 를 반환합니다.
    func getCurrentWiFiSSID() -> Single<String?>
}

class DefaultWiFiConnectRepository: WiFiConnectRepository {
    private let disposeBag = DisposeBag()
    private let wifiConnectionStatusSubject = BehaviorSubject<Bool>(value: false)

    public var wifiConnectionStatus: Observable<Bool> {
        return wifiConnectionStatusSubject.asObservable()
    }

    // MARK: - Wi-Fi 연결 시도
    public func connectToWiFi(ssid: String, password: String) -> Single<Bool> {

        return Single<Bool>.create { single in
            let config = NEHotspotConfiguration(ssid: ssid,
                                                passphrase: password,
                                                isWEP: false)
            config.joinOnce = false

            /// 접속 여부를 자체적으로 판단 하지 않는다. 따라서 네트워크 연결 상태를 알려주는 함수 필요
            NEHotspotConfigurationManager.shared.apply(config) { error in
                if let err = error as? NSError {
                    print("여기11")
                    switch err.code {
                    /// <Alert없이 바로 retry>
                    /// 1) PW가 ""일 때
                    /// 2) ID는 맞으나 PW가 틀렸을 때 (?? 다른 와이파이)
                    /// 3) PW가 8자리 미만
                    /// 4) WiFi 라벨과 PW만 있을 때 (로직 상 PW를 ID로 먼저 인식)
                    case NEHotspotConfigurationError.invalidWPAPassphrase.rawValue:
                        Log.print("1) PW가 ''일때 2) ID는 맞으나 PW가 틀렸을 때 3) PW가 8자리 미만 - Alert 없이 바로 Retry")
                        single(.failure(WiFiConnectionErrors.invalidPassword(ssid)))
                        print("여기invalidPassword")

                    /// <Alert없이 바로 retry>
                    /// 1) IP&PW 모두 맞으나 해당 WiFi에 이미 접속 상태
                    /// 2) ID는 맞으나 PW가 틀렸을 때 (같은 와이파이)
                    case NEHotspotConfigurationError.alreadyAssociated.rawValue:
                        Log.print("1) IP&PW 모두 맞으나 해당 WiFi에 이미 접속 상태 2) ID는 맞으나 PW가 틀렸을 때(같은 와이파이) - Alert 없이 바로 Retry")
                        single(.failure(WiFiConnectionErrors.alreadyConnected(ssid)))
                        print("여기invalidalreadyConnected")

                    /// <Alert없이 바로 retry>
                    /// 1) ID가 ""일 때
                    /// 2) ID&PW가 ""일 때
                    case NEHotspotConfigurationError.invalidSSID.rawValue:
                        Log.print("1) ID가 ''일때 2) ID&PW가 ''일때 - Alert 없이 바로 Retry")
                        single(.failure(WiFiConnectionErrors.invalidSSID))

                    /// 취소버튼 터치 완료
                    case NEHotspotConfigurationError.userDenied.rawValue:
                        Log.print("Alert - 취소버튼 터치 완료")
                        single(.failure(WiFiConnectionErrors.userDenied))

                    default:
                        print("보지 못한 에러입니다.: \(err.localizedDescription)")
                        single(.failure(err))  // 기타 에러 처리
                    }
                }

                // 에러가 없을 경우 와이파이에 접속이 되었는지 판단 하는 과정이 필요
                else {
                    print("여기22")
                    Log.print("Alert - 연결버튼 터치 완료")
                    self.getCurrentWiFiSSID().subscribe(onSuccess: { currentSSID in
                        print("여기33")
                        // 접속하려는 와이파이와 연결된 와이파이가 같음
                        if currentSSID == ssid {
                            print("Successfully connected to \(ssid)")
                            single(.success(true))
                        }
                        // 접속하려는 와이파이와 연결된 와이파이가 다름
                        else {
                            print("여기44")

                            /// 1) ID&PW 둘 다 틀렸을 때
                            /// 2) ID는 틀렸으나 PW 맞을 때
                            Log.print("1) ID&PW 둘다 틀렸을 때 2) ID는 틀렸으나 PW 맞을 때")
                            Log.print("'다음 네트워크에 연결할 수 없다' Alert")
                            print("Failed to connect to \(ssid)")
                            single(.failure(WiFiConnectionErrors.failedToConnect(ssid)))
                        }
                    })
                    .disposed(by: self.disposeBag)

                }
            }
            return Disposables.create()
        }
    }

    // MARK: - 비동기 SSID 가져오기
    func getCurrentWiFiSSID() -> Single<String?> {
        return Single<String?>.create { single in
            NEHotspotNetwork.fetchCurrent { network in
                print("여기getget")
                // 연결된 ssid 반환
                if let ssid = network?.ssid {
                    print("현재 SSID: \(ssid)")
                    single(.success(ssid))
                }
                // 연결된 ssid가 없음
                else {
                    print("와이파이가 연결되어 있지 않거나 위치 정보가 없습니다.")
                    single(.success(nil))
                }
            }
            return Disposables.create()
        }
    }

    // MARK: - Wi-Fi 연결 상태 확인
    func isWiFiConnectedcheck() -> Single<Bool> {
        return getCurrentWiFiSSID().map { ssid in
            return ssid != nil
        }
    }
}
