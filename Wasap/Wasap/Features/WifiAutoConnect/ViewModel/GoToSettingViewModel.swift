//
//  GoToSettingViewModel.swift
//  Wasap
//
//  Created by 김상준 on 10/15/24.
//

import Foundation
import RxSwift
import UIKit
import RxCocoa

public class GoToSettingViewModel: BaseViewModel {

    // MARK: - Coordinator
    private weak var coordinatorController: GoToSettingCoordinator?

    // MARK: - Input
    let setButtonTapped = PublishSubject<Void>()
    let xButtonTapped = PublishSubject<Void>()

    // MARK: - Output
    let ssidDriver: Driver<String>
    let passwordDriver: Driver<String>


    public init(gotoSettingUseCase: GoToSettingUseCase, coordinatorController: GoToSettingCoordinator,ssid : String, password: String) {

        self.coordinatorController = coordinatorController


        let ssidRelay = BehaviorRelay<String>(value: ssid)
        self.ssidDriver = ssidRelay.asDriver()

        let passwordRelay = BehaviorRelay<String>(value: password)
        self.passwordDriver = passwordRelay.asDriver()

        super.init()


        viewDidLoad
            .subscribe(onNext: {
                print("SSID: \(ssidRelay.value), Password: \(passwordRelay.value)")
            })
            .disposed(by: disposeBag)

        xButtonTapped
            .subscribe(onNext: { _ in
                self.coordinatorController?.performTransition(to: .camera)
                print("hello")
            })
            .disposed(by: disposeBag)

        setButtonTapped
            .subscribe(onNext: {
                gotoSettingUseCase.openSettings()
            })
            .disposed(by: disposeBag)
    }
}

