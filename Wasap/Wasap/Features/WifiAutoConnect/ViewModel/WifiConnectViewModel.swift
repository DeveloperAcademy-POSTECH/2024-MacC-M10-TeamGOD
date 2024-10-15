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
    private weak var coordinatorController: WifiConnectCoordinatorController?
    // MARK: - Input
    public let reConnectButtonTapped = PublishRelay<Void>()
    public let ssidText = BehaviorRelay<String>(value: "")
    public let pwText = BehaviorRelay<String>(value: "")
    public let cameraButtonTapped = PublishRelay<Void>()

    // MARK: - Output


    public init(wifiConnectUseCase: WiFiConnectUseCase,coordinatorController: WifiConnectCoordinatorController) {
        self.coordinatorController = coordinatorController
        super.init()
        // MARK: 다시 와이파이 연결

        cameraButtonTapped
            .subscribe(onNext: { _ in
                self.coordinatorController?.performTransition(to: .camera)
                print("hello")
            })
            .disposed(by: disposeBag)

        reConnectButtonTapped
            .withLatestFrom(Observable.combineLatest(ssidText, pwText))
            .subscribe(onNext: { ssid, password in
                print(ssid, password)
                self.coordinatorController?.performTransition(to: .connecting(ssid: ssid, password: password))
                print("hello")
            })
            .disposed(by: disposeBag)
    }
}
