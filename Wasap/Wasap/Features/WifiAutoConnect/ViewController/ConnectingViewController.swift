//
//  ConnectingViewController.swift
//  Wasap
//
//  Created by Chang Jonghyeon on 10/14/24.
//

import RxSwift
import RxCocoa
import UIKit

public class ConnectingViewController: RxBaseViewController<ConnectingViewModel> {
    private let connectingView = ConnectingView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func loadView() {
        super.loadView()
        self.view = connectingView
    }
    
    override init(viewModel: ConnectingViewModel) {
        super.init(viewModel: viewModel)
        bind(viewModel)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(_ viewModel: ConnectingViewModel) {
        // 뷰 -> 뷰모델
        
        // 뷰모델 -> 뷰

    }
}
