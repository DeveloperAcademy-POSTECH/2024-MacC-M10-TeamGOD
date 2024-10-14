//
//  GoToSettingUseCase.swift
//  Wasap
//
//  Created by 김상준 on 10/15/24.
//

import RxSwift
import Foundation

public protocol GoToSettingUseCase {
}

final class DefaultGoToSettingUseCase: GoToSettingUseCase {
    private let repository: GoToSettingRepository
    
    init(repository: GoToSettingRepository) {
        self.repository = repository
    }

}
