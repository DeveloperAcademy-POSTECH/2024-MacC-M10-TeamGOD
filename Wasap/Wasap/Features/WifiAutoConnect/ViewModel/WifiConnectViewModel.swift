//
//  WifiConnectViewModel.swift
//  Wasap
//
//  Created by 김상준 on 10/7/24.
//

import RxSwift
import RxCocoa

public class WifiConnectViewModel: BaseViewModel {
    
    // MARK: - Coordinator
    private weak var coordinatorController: WifiConnectCoordinator?
    
    // MARK: - Input
    public let reConnectButtonTapped = PublishRelay<Void>()
    public let resetButtonTapped = PublishRelay<Void>()
    public let ssidText = BehaviorRelay<String>(value: "")
    public let pwText = BehaviorRelay<String>(value: "")
    
    // MARK: - Output
    public var completeText: Driver<String>
    public var newSsidText: Driver<String>
    public var newPwText: Driver<String>
    public var isLoading: Driver<Bool>
    
    public init(wifiConnectUseCase: WiFiConnectUseCase, coordinatorController: WifiConnectCoordinator) {
        
        let isLoadingRelay = BehaviorRelay<Bool>(value: false)
        self.isLoading = isLoadingRelay.asDriver()
        
        let iscompleteTextRelay = BehaviorRelay(value: "")
        self.completeText = iscompleteTextRelay.asDriver(onErrorJustReturn: "")
        
        let newSsidTextRelay = BehaviorRelay(value: "")
        self.newSsidText = newSsidTextRelay.asDriver(onErrorJustReturn: "")
        
        let newPwTextRelay = BehaviorRelay(value: "")
        self.newPwText = newPwTextRelay.asDriver(onErrorJustReturn: "")
        
        self.coordinatorController = coordinatorController
        super.init()
        
        reConnectButtonTapped
            .withLatestFrom(Observable.combineLatest(ssidText, pwText))
            .flatMapLatest { (ssid, password) in
                return wifiConnectUseCase.connectToWiFi(ssid: ssid, password: password)
                    .asObservable()
                    .catch { error in
                        let errorMessage = "Connection failed: \(error.localizedDescription)"
                        iscompleteTextRelay.accept(errorMessage)
                        return Observable.just(false)
                    }
            }
            .subscribe(onNext: { success in
                let statusMessage = success ? "연결 성공했습니다." : "연결 실패했습니다."
                iscompleteTextRelay.accept(statusMessage)
            })
            .disposed(by: disposeBag)
        
        
        resetButtonTapped
            .subscribe(onNext: {
                newPwTextRelay.accept("")
                newSsidTextRelay.accept("")
                iscompleteTextRelay.accept("초기화 완료")
            })
            .disposed(by: disposeBag)
    }
}
