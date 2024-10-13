//
//  ViewController.swift
//  Wasap
//
//  Created by chongin on 10/3/24.
//
import UIKit
import RxSwift
import SnapKit

public class WifiReConnectViewController: RxBaseViewController<WifiConnectViewModel>{
    
    private let wifiReConnectView = WifiReConnectView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func loadView() {
        super.loadView()
        self.view = wifiReConnectView
    }

    override init(viewModel: WifiConnectViewModel) {
        super.init(viewModel: viewModel)
        bind(viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind(_ viewModel: WifiConnectViewModel) {
        
        wifiReConnectView.ssidField.rx.text.orEmpty
            .bind(to: viewModel.ssidText)
            .disposed(by: disposeBag)
        
        wifiReConnectView.pwField.rx.text.orEmpty
            .bind(to: viewModel.pwText)
            .disposed(by: disposeBag)
        
//        wifiReConnectView.reConnectButton.rx.tap
//            .bind(to: viewModel.reConnectButtonTapped)
//            .disposed(by: disposeBag)
//        
//        wifiConnectView.resetButton.rx.tap
//            .bind(to: viewModel.resetButtonTapped)
//            .disposed(by: disposeBag)
//        
        
        viewModel.newSsidText
            .drive { [weak self] newSsidText in
                self?.wifiReConnectView.ssidField.text = newSsidText
            }
            .disposed(by: disposeBag)
        
        viewModel.newPwText
            .drive { [weak self] newPwText in
                self?.wifiReConnectView.pwField.text = newPwText
            }
            .disposed(by: disposeBag)
        
        
//        viewModel.completeText
//            .drive { [weak self] status in
//                self?.wifiConnectView.statusLabel.text = status
//            }
//            .disposed(by: disposeBag)
    }
}
