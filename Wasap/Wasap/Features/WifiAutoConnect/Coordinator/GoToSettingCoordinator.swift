//
//  GotoSettingCoordinator.swift
//  Wasap
//
//  Created by 김상준 on 10/15/24.
//

import Foundation
import UIKit

public class GoToSettingCoordinator: NavigationCoordinator {
    public var childCoordinators: [any Coordinator] = []
    public let navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public enum Flow {
        case detail
    }
    
    public func start() {
        let repository = DefaultGoToSettingRepository()
        
        let usecase = DefaultGoToSettingUseCase(repository: repository)
        
        let viewModel = GoToSettingViewModel(gotoSettingUseCase: usecase, coordinatorController: self)
        
        let viewController = GoToSettingViewController(viewModel: viewModel)
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
