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
    
    public init(wifiConnectUseCase: WiFiConnectUseCase, coordinatorController: ConnectingCoordinatorController) {
        
        let isWiFiConnectedRelay = BehaviorRelay<Bool>(value: false)
        self.isWiFiConnected = isWiFiConnectedRelay.asDriver(onErrorJustReturn: false)
        
        self.coordinatorController = coordinatorController
        super.init()
        
        wifiConnectUseCase.observeWiFiConnection()
            .subscribe(onNext: { success in
                isWiFiConnectedRelay.accept(success)
            }, onError: { error in
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
