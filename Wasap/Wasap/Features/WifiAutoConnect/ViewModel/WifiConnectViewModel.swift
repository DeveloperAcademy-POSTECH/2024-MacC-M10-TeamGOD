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

    public init(wifiConnectUseCase: WiFiConnectUseCase, coordinatorController: WifiConnectCoordinatorController, image: UIImage, ssid: String, password: String) {
        self.coordinatorController = coordinatorController

        let updatedImageRelay = BehaviorRelay<UIImage>(value: image)
        self.updatedImageDriver = updatedImageRelay.asDriver()

        self.ssidText.accept(ssid)
        self.pwText.accept(password)
        self.image.accept(image)

        super.init()
        // MARK: 다시 와이파이 연결

        cameraButtonTapped
            .subscribe(onNext: { _ in
                self.coordinatorController?.performTransition(to: .camera)
                print("hello")
            })
            .disposed(by: disposeBag)

        reConnectButtonTapped
            .withLatestFrom(Observable.combineLatest(self.image, self.ssidText, self.pwText))
            .subscribe(onNext: {  image ,ssid, password in
                print(image,ssid, password)
                self.coordinatorController?.performTransition(to: .connecting(imageData: image,ssid: ssid, password: password))
            })
            .disposed(by: disposeBag)
    }
}
