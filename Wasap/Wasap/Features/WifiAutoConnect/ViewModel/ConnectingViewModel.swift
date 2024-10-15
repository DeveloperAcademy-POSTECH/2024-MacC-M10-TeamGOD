//
//  ConnectingViewModel.swift
//  Wasap
//
//  Created by Chang Jonghyeon on 10/14/24.
//

import RxSwift
import RxCocoa
import UIKit

public class ConnectingViewModel: BaseViewModel {
    // MARK: - Coordinator
    private weak var coordinatorController: ConnectingCoordinatorController?
    
    // MARK: - Input
    public let quitButtonTapped = PublishRelay<Void>()
    
    // MARK: - Output
    public var isWiFiConnected: Driver<Bool>
    public var isLoading: Driver<Bool>
    
    public init(wifiConnectUseCase: WiFiConnectUseCase, coordinatorController: ConnectingCoordinatorController) {
        
        let isWiFiConnectedRelay = BehaviorRelay<Bool>(value: false)
        self.isWiFiConnected = isWiFiConnectedRelay.asDriver(onErrorJustReturn: false)
        
        let isLoadingRelay = BehaviorRelay<Bool>(value: false)
        self.isLoading = isLoadingRelay.asDriver(onErrorJustReturn: false)
        
        self.coordinatorController = coordinatorController
        super.init()
        
        self.viewDidLoad
            .flatMapLatest { _ in
                isLoadingRelay.accept(true)
                return wifiConnectUseCase.observeWiFiConnection()
            }
            .subscribe(onNext: { success in
                isLoadingRelay.accept(false)
                if success {
                    isWiFiConnectedRelay.accept(success)
                }
            }, onError: { error in
                isLoadingRelay.accept(false)
                print("Wi-Fi 연결 중 에러 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
        
        self.quitButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { _ in
                Log.debug("quit Button Tapped")
                print("닫아!닫으라고!닫아!!!!")
            })
            .disposed(by: disposeBag)
    }
}
