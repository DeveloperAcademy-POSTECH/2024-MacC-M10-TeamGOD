//
//  GoToSettingUseCase.swift
//  Wasap
//
//  Created by 김상준 on 10/15/24.
//

import RxSwift
import Foundation
import UIKit

public protocol GoToSettingUseCase {
    func openSettings()
}

final class DefaultGoToSettingUseCase: GoToSettingUseCase {
    private let repository: GoToSettingRepository
    
    init(repository: GoToSettingRepository) {
        self.repository = repository
    }

    func openSettings() {
        if let settingsURL = URL(string: "App-Prefs:") {
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            } else {
                print("설정 앱을 열 수 없습니다.")
            }
        }
    }
}

