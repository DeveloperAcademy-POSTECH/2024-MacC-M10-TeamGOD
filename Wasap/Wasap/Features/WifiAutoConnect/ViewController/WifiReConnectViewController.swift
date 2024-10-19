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
        // MARK: SSID 값이 변경될 때 마다 ViewModel로 전달
        wifiReConnectView.ssidField.rx.text.orEmpty
            .bind(to: viewModel.ssidText)
            .disposed(by: disposeBag)

        // MARK: SSID FIELD 터치
        wifiReConnectView.ssidField.rx.controlEvent(.editingDidBegin)
            .bind(to: viewModel.ssidFieldTouched)
                    .disposed(by: disposeBag)

        // MARK: PASSWORD 값이 변경될 때 마다 ViewModel로 전달
        wifiReConnectView.pwField.rx.text.orEmpty
            .bind(to: viewModel.pwText)
            .disposed(by: disposeBag)

        // MARK: PASSWORD FIELD 터치
        wifiReConnectView.pwField.rx.controlEvent(.editingDidBegin)
            .bind(to: viewModel.pwFieldTouched)
            .disposed(by: disposeBag)

        // MARK: ReConnect 버튼이 눌렸을 때 ViewModel 트리거
        wifiReConnectView.reConnectButton.rx.tap
            .bind(to: viewModel.reConnectButtonTapped)
            .disposed(by: disposeBag)

        // MARK: ViewModel에서 버튼 색상 상태를 구독하여 UI 업데이트
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

        // MARK: ViewModel로부터 SSID COLOR 값 전달 받기
        viewModel.ssidTextFieldTouchedDriver
            .drive(onNext: { [weak self] isEnabled in
                self?.wifiReConnectView.ssidLabel.textColor = isEnabled ? .green200 : .neutral200

                self?.wifiReConnectView.ssidField.layer.borderColor = isEnabled ? UIColor.green200.cgColor : UIColor.neutral200.cgColor

                self?.wifiReConnectView.ssidField.layer.borderWidth = isEnabled ? 1 : 0
            })
            .disposed(by: disposeBag)

        // MARK: ViewModel로 부터 PASSWORD 값 전달 받기
        viewModel.passwordDriver
            .drive(wifiReConnectView.pwField.rx.text)
            .disposed(by: disposeBag)

        // MARK: ViewModel로부터 PASSWORD COLOR 값 전달 받기
        viewModel.pwTextFieldTouchedDriver
            .drive(onNext: { [weak self] isEnabled in
                self?.wifiReConnectView.pwLabel.textColor = isEnabled ? .green200 : .neutral200

                self?.wifiReConnectView.pwField.layer.borderColor = isEnabled ? UIColor.green200.cgColor :  UIColor.neutral200.cgColor

                self?.wifiReConnectView.pwField.layer.borderWidth = isEnabled ? 1 : 0
            })
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
