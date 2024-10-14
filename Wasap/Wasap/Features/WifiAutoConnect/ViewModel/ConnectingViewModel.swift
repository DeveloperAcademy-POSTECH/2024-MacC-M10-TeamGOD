//
//  ConnectingViewModel.swift
//  Wasap
//
//  Created by Chang Jonghyeon on 10/14/24.
//

import RxSwift
import RxCocoa
import UIKit

public class ConnectingViewModel: BaseViewModel {
    // MARK: - Coordinator
    private weak var coordinatorController: ConnectingCoordinatorController?
    
    // MARK: - Input
    
    // MARK: - Output
    
    public init(wifiConnectUseCase: WiFiConnectUseCase, coordinatorController: ConnectingCoordinatorController) {
        
        self.coordinatorController = coordinatorController
        super.init()

    }
}
