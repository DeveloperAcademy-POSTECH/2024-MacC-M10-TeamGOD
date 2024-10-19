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

public class WifiReConnectViewController: RxBaseViewController<WifiReConnectViewModel>{

    private let wifiReConnectView = WifiReConnectView()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }

    public override func loadView() {
        super.loadView()
        self.view = wifiReConnectView
    }

    override init(viewModel: WifiReConnectViewModel) {
        super.init(viewModel: viewModel)
        bind(viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind(_ viewModel: WifiReConnectViewModel) {
        // 텍스트 필드의 값이 변경될 때마다 ViewModel로 전달
        wifiReConnectView.ssidField.rx.text.orEmpty
            .bind(to: viewModel.ssidText)
            .disposed(by: disposeBag)

        wifiReConnectView.pwField.rx.text.orEmpty
            .bind(to: viewModel.pwText)
            .disposed(by: disposeBag)

        // ReConnect 버튼이 눌렸을 때 ViewModel의 이벤트 트리거
        wifiReConnectView.reConnectButton.rx.tap
            .bind(to: viewModel.reConnectButtonTapped)
            .disposed(by: disposeBag)

        // ViewModel에서 버튼 색상 상태를 구독하여 UI 업데이트
        viewModel.btnColorChangeDriver
            .drive(onNext: { [weak self] isEnabled in
                guard let self = self else { return }
                self.wifiReConnectView.reConnectButton.backgroundColor = isEnabled ? .green200 : .clear
                self.wifiReConnectView.reConnectButton.setTitleColor(isEnabled ? .black : .neutral200, for: .normal)
            })
            .disposed(by: disposeBag)

        // MARK: ViewModel로부터 SSID 값 전달 받기
        viewModel.ssidDriver
            .drive(wifiReConnectView.ssidField.rx.text)
            .disposed(by: disposeBag)
        // MARK: ViewModel로 부터 PW 값 전달 받기
        viewModel.passwordDriver
            .drive(wifiReConnectView.pwField.rx.text)
            .disposed(by: disposeBag)

        // MARK: ViewModel로 부터 이미지 값 전달 받기
        viewModel.updatedImageDriver
            .drive(wifiReConnectView.photoImageView.rx.image)
            .disposed(by: disposeBag)
    }

    private func setupActions() {
        wifiReConnectView.cameraButton.addTarget(self, action: #selector(CameraButtonTapped), for: .touchUpInside)
    }

    @objc private func CameraButtonTapped() {
        // 버튼 클릭 시 처리할 로직
        print("Camera button tapped")
        dismiss(animated: true, completion: nil) // 현재 화면 닫기
    }
}
