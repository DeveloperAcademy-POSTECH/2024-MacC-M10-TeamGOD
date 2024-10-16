//
//  WifiConnectViewModel.swift
//  Wasap
//
//  Created by 김상준 on 10/7/24.
//

import RxSwift
import RxCocoa
import UIKit

public class WifiReConnectViewModel: BaseViewModel {

    // MARK: - Coordinator
    private weak var coordinatorController: WifiReConnectCoordinatorController?

    // MARK: - Input
    public let reConnectButtonTapped = PublishRelay<Void>()
    public let cameraButtonTapped = PublishRelay<Void>()

    public let ssidText = BehaviorRelay<String>(value: "")
    public let pwText = BehaviorRelay<String>(value: "")
    public let photoImage = BehaviorRelay<UIImage>(value: UIImage())

    // MARK: - Output
    let ssidDriver: Driver<String>
    let passwordDriver: Driver<String>
    let updatedImageDriver: Driver<UIImage>

    public init(wifiConnectUseCase: WiFiConnectUseCase,
                coordinatorController: WifiReConnectCoordinatorController,
                image: UIImage, ssid: String, password: String) {

        self.coordinatorController = coordinatorController

        let updatedImageRelay = BehaviorRelay<UIImage>(value: image)
        self.updatedImageDriver = updatedImageRelay.asDriver()

        let ssidRelay = BehaviorRelay<String>(value: ssid)
        self.ssidDriver = ssidRelay.asDriver()

        let passwordRelay = BehaviorRelay<String>(value: password)
        self.passwordDriver = passwordRelay.asDriver()

        super.init()

        cameraButtonTapped
            .subscribe(onNext: { _ in
                self.coordinatorController?.performFinish(to: .popToRoot)
            })
            .disposed(by: disposeBag)

        reConnectButtonTapped
            .withLatestFrom(Observable.combineLatest(self.photoImage, self.ssidText, self.pwText))
            .subscribe(onNext: { [weak self] image, ssid, password in
                guard let self = self else { return }

                // 화면 전환 수행
                self.coordinatorController?.performTransition(to: .connecting(
                    imageData: image,
                    ssid: ssid,
                    password: password
                ))
            })
            .disposed(by: disposeBag)
    }
}
