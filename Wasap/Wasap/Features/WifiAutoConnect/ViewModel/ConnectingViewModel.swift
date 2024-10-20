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

    // MARK: - UseCase
    private let wifiConnectUseCase: WiFiConnectUseCase

    // MARK: - Input
    public let quitButtonTapped = PublishRelay<Void>()
    
    // MARK: - Output
    public var isWiFiConnected: Driver<Bool>
    public var isLoading: Driver<Bool>
    
    public init(wifiConnectUseCase: WiFiConnectUseCase, coordinatorController: ConnectingCoordinatorController, image: UIImage, ssid: String, password: String) {
        self.wifiConnectUseCase = wifiConnectUseCase

        let isWiFiConnectedRelay = BehaviorRelay<Bool>(value: false)
        self.isWiFiConnected = isWiFiConnectedRelay.asDriver(onErrorJustReturn: false)
        
        let isLoadingRelay = BehaviorRelay<Bool>(value: false)
        self.isLoading = isLoadingRelay.asDriver(onErrorJustReturn: false)
        
        self.coordinatorController = coordinatorController
        super.init()
        
        viewDidLoad
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                isLoadingRelay.accept(true)
                return wifiConnectUseCase.connectToWiFi(ssid: ssid, password: password)
            }
            .subscribe { success in
                isLoadingRelay.accept(false)
                isWiFiConnectedRelay.accept(success)
            } onError: { error in
                isLoadingRelay.accept(false)
                print("여기55:\(error)")
                self.coordinatorController?.performFinish(to: .finishWithError)
                Log.error("Wi-Fi 연결 중 에러 발생: \(error.localizedDescription)")
            }
            .disposed(by: disposeBag)
        
        self.quitButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.coordinatorController?.performFinish(to: .popToRoot)
            })
            .disposed(by: disposeBag)
    }
}
