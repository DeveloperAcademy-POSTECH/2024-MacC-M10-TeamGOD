//
//  ViewController.swift
//  Wasap
//
//  Created by chongin on 10/3/24.
//
import UIKit
import RxSwift
import SnapKit
import CoreLocation

public class WifiReConnectViewController: RxBaseViewController<WifiConnectViewModel>{
    
    private let wifiReConnectView = WifiReConnectView()
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActions()
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
        
        wifiReConnectView.reConnectButton.rx.tap
            .bind(to: viewModel.reConnectButtonTapped)
            .disposed(by: disposeBag)

        wifiReConnectView.cameraButton.rx.tap
            .bind(to: viewModel.cameraButtonTapped)
            .disposed(by: disposeBag)

//        
////        viewModel.completeText
////            .drive {  status in
////                print(status)
//////                self?.wifiReConnectView.statusLabel.text = status
////            }
//            .disposed(by: disposeBag)
    }
    private func setupActions() {
        wifiReConnectView.cameraButton.addTarget(self, action: #selector(CameraButtonTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = wifiReConnectView.barItem
        navigationItem.rightBarButtonItem?.customView?.frame = CGRect(x: 0, y: 300, width: 26, height: 26)
    }
    
    @objc private func CameraButtonTapped() {
        // 버튼 클릭 시 처리할 로직
        print("Camera button tapped")
        dismiss(animated: true, completion: nil) // 현재 화면 닫기
    }
}


