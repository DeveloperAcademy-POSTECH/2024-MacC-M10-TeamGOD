//
//  ViewController.swift
//  Wasap
//
//  Created by chongin on 10/3/24.
//
import UIKit
import RxSwift
import SnapKit

public class WifiConnectViewController: RxBaseViewController<WifiConnectViewModel>{
    
    private let wifiConnectView = WifiConnectView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func loadView() {
        super.loadView()
        self.view = wifiConnectView
    }

    override init(viewModel: WifiConnectViewModel) {
        super.init(viewModel: viewModel)
        bind(viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind(_ viewModel: WifiConnectViewModel) {
        
        wifiConnectView.ssidField.rx.text.orEmpty
            .bind(to: viewModel.ssidText)
            .disposed(by: disposeBag)
        
        wifiConnectView.pwField.rx.text.orEmpty
            .bind(to: viewModel.pwText)
            .disposed(by: disposeBag)
        
        wifiConnectView.connectButton.rx.tap
            .bind(to: viewModel.connectButtonTapped)
            .disposed(by: disposeBag)
        
        wifiConnectView.resetButton.rx.tap
            .bind(to: viewModel.resetButtonTapped)
            .disposed(by: disposeBag)
        
        
        viewModel.newSsidText
            .drive { [weak self] newSsidText in
                self?.wifiConnectView.ssidField.text = newSsidText
            }
            .disposed(by: disposeBag)
        
        viewModel.newPwText
            .drive { [weak self] newPwText in
                self?.wifiConnectView.pwField.text = newPwText
            }
            .disposed(by: disposeBag)
        
        
        viewModel.completeText
            .drive { [weak self] status in
                self?.wifiConnectView.statusLabel.text = status
            }
            .disposed(by: disposeBag)
    }
}

