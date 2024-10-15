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
    public let ssidText = BehaviorRelay<String>(value: "")
    public let pwText = BehaviorRelay<String>(value: "")
    
    // MARK: - Output
    public var completeText: Driver<String>
    public var isLoading: Driver<Bool>
    
    let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    let iscompleteTextRelay = BehaviorRelay(value: "")
    
    public init(wifiConnectUseCase: WiFiConnectUseCase, coordinatorController: WifiConnectCoordinator) {
        
        self.isLoading = isLoadingRelay.asDriver()
        self.completeText = iscompleteTextRelay.asDriver(onErrorJustReturn: "")
        
        self.coordinatorController = coordinatorController
        super.init()
        
        // MARK: 다시 와이파이 연결
        reConnectButtonTapped
            .withLatestFrom(Observable.combineLatest(ssidText, pwText))
            .do(onNext: { _ in
                self.isLoadingRelay.accept(true)  // 로딩 시작
            })
            .flatMapLatest { (ssid, password) in
                return wifiConnectUseCase.connectToWiFi(ssid: ssid, password: password)
                    .asObservable()
                
                    .catch { error in
                        let errorMessage = "연결 실패: \(error.localizedDescription)"
                        self.iscompleteTextRelay.accept(errorMessage)
                        self.isLoadingRelay.accept(false)  // 로딩 종료
                        print(errorMessage)
                        return Observable.just(false)
                    }
                
            }
            .subscribe(onNext: { [weak self] success in
                guard let self = self else { return }
                self.isLoadingRelay.accept(false)  // 로딩 종료
                
                if success {
                    self.iscompleteTextRelay.accept("연결 성공했습니다.")
                } else {
                    self.iscompleteTextRelay.accept("연결에 실패했습니다.")
                    
                    
                }
            })
            .disposed(by: disposeBag)
    }
}

protocol WifiConnectTranslater {
    func perfromTransition(_ flow: WifiConnectCoordinator.Flow)
}
