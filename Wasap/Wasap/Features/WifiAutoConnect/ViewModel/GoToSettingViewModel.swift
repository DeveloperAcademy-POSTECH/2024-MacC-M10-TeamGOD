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
    private weak var coordinatorController: GoToSettingCoordinatorController?

    // MARK: - Input
    let setButtonTapped = PublishRelay<Void>()
    let xButtonTapped = PublishRelay<Void>()

    // MARK: - Property
    let ssidDriver: Driver<String>
    let passwordDriver: Driver<String>
    let imageDriver: Driver<UIImage>

    public init(goToSettingUseCase: GoToSettingUseCase,
                coordinatorController: GoToSettingCoordinatorController,
                imageData: UIImage, ssid : String, password: String) {

        self.coordinatorController = coordinatorController

        let imageRelay = BehaviorRelay<UIImage>(value: imageData)
        self.imageDriver = imageRelay.asDriver()

        let ssidRelay = BehaviorRelay<String>(value: ssid)
        self.ssidDriver = ssidRelay.asDriver()

        let passwordRelay = BehaviorRelay<String>(value: password)
        self.passwordDriver = passwordRelay.asDriver()

        super.init()

        xButtonTapped
            .subscribe(onNext: { _ in
                self.coordinatorController?.performFinish(to: .popToRoot)
            })
            .disposed(by: disposeBag)

        setButtonTapped
            .subscribe(onNext: {
                goToSettingUseCase.openSettings()
                goToSettingUseCase.copyPassword(pw: password)
            })
            .disposed(by: disposeBag)
    }
}


