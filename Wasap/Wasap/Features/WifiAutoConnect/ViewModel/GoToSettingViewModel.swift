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
    
    // MARK: - Output
    
    public init(gotoSettingUseCase: GoToSettingUseCase, coordinatorController: GoToSettingCoordinator) {
        
        self.coordinatorController = coordinatorController
        super.init()
        setButtonTapped
            .subscribe(onNext: {
                gotoSettingUseCase.openSettings()
            })
            .disposed(by: disposeBag)
    }
}

