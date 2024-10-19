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
    public let ssidFieldTouched = PublishRelay<Void>()
    public let pwFieldTouched = PublishRelay<Void>()

    public let ssidText = BehaviorRelay<String>(value: "")
    public let pwText = BehaviorRelay<String>(value: "")
    public let photoImage = BehaviorRelay<UIImage>(value: UIImage())

    // MARK: - Output
    let ssidDriver: Driver<String>
    let passwordDriver: Driver<String>
    let updatedImageDriver: Driver<UIImage>

    let btnColorChangeDriver: Driver<Bool>
    let ssidTextFieldTouchedDriver: Driver<Bool>
    let pwTextFieldTouchedDriver: Driver<Bool>

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

        let btnColorChangeRelay = BehaviorRelay<Bool>(value: false)
        self.btnColorChangeDriver = btnColorChangeRelay.asDriver()

        let ssidTextFieldColorChangeRelay = BehaviorRelay<Bool>(value: false)
        self.ssidTextFieldTouchedDriver = ssidTextFieldColorChangeRelay.asDriver()

        let pwTextFieldColorChangeRelay = BehaviorRelay<Bool>(value: false)
        self.pwTextFieldTouchedDriver = pwTextFieldColorChangeRelay.asDriver()

        super.init()

        ssidText
            .skip(2)
            .distinctUntilChanged()
            .subscribe(onNext:{ ssidText in
                if (ssidText != ssid) {
                    print("ssid:\(ssid),ssidText:\(ssidText)")
                    btnColorChangeRelay.accept(true)
                }else {
                    btnColorChangeRelay.accept(false)
                }
            })
            .disposed(by: disposeBag)

        pwText
            .skip(2)
            .distinctUntilChanged()
            .subscribe(onNext:{ pwText in
                if (pwText != password) {
                    print("password:\(password),pwText:\(pwText)")
                    btnColorChangeRelay.accept(true)
                } else {
                    btnColorChangeRelay.accept(false)
                }
            })
            .disposed(by: disposeBag)

        ssidFieldTouched
            .subscribe(onNext: { () in
                ssidTextFieldColorChangeRelay.accept(true)
                pwTextFieldColorChangeRelay.accept(false)
            })
            .disposed(by: disposeBag)

        pwFieldTouched
            .subscribe(onNext: { () in
                ssidTextFieldColorChangeRelay.accept(false)
                pwTextFieldColorChangeRelay.accept(true)
            })
            .disposed(by: disposeBag)

        // 카메라 버튼이 눌렸을 때
        cameraButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.coordinatorController?.performFinish(to: .popToRoot)
            })
            .disposed(by: disposeBag)

        // 재연결 버튼이 눌렸을 때
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
