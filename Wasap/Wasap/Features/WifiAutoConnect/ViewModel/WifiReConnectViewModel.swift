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
    public let btnColorChangeDriver: Driver<Bool>

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

        super.init()

//        // SSID와 PW 값이 변경될 때 두 번의 초기 이벤트를 무시
//        Observable.combineLatest(ssidText, pwText)
//            .skip(2) // 두 번의 초기값 전달 무시
//            .distinctUntilChanged { ssidInput, pwInput in
//                // 값이 변경되었는지 확인 (초기값과 동일한지 비교)
//                return ssidInput == ssid && pwInput == password
//            }
//            .subscribe(onNext: { [weak self] ssidInput, pwInput in
//                guard let self = self else { return }
//                // 값이 달라졌을 때 버튼 색상 변경
//                let isDifferent = ssidInput != ssid || pwInput != password
//                btnColorChangeRelay.accept(isDifferent)
//            })
//            .disposed(by: disposeBag)

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
