//
//  WifiConnectViewModel.swift
//  Wasap
//
//  Created by 김상준 on 10/7/24.
//

import RxSwift
import RxCocoa
import UIKit

public class WifiConnectViewModel: BaseViewModel {

    // MARK: - Coordinator
    private weak var coordinatorController: WifiConnectCoordinatorController?
    // MARK: - Input
    public let reConnectButtonTapped = PublishRelay<Void>()
    public let ssidText = BehaviorRelay<String>(value: "")
    public let pwText = BehaviorRelay<String>(value: "")
    public let image = BehaviorRelay<UIImage>(value: UIImage())
    public let cameraButtonTapped = PublishRelay<Void>()

    // MARK: - Output
    public var updatedImageDriver: Driver<UIImage>

    public init(wifiConnectUseCase: WiFiConnectUseCase,coordinatorController: WifiConnectCoordinatorController) {

        let updatedImageRelay = BehaviorRelay<UIImage?>(value: nil)
        self.updatedImageDriver = updatedImageRelay.asDriver(onErrorJustReturn: nil).compactMap { $0 }

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
            .withLatestFrom(Observable.combineLatest(image,ssidText, pwText))
            .subscribe(onNext: {  image ,ssid, password in
                print(image,ssid, password)
                self.coordinatorController?.performTransition(to: .connecting(imageData: image,ssid: ssid, password: password))
            })
            .disposed(by: disposeBag)
    }
}
