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
import RxGesture

public class WifiReConnectViewController: RxBaseViewController<WifiReConnectViewModel>{

    private let wifiReConnectView = WifiReConnectView()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardNotifications()
        view.keyboardLayoutGuide.usesBottomSafeArea = false
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

        // MARK: BackGround 터치하면 ViewModel 트리거
        wifiReConnectView.rx.tapGesture()
            .when(.recognized)
            .map { _ in } // 이벤트를 빈 값으로 변환하여 Relay로 전달
            .bind(to: viewModel.bgTouched)
            .disposed(by: disposeBag)

        // MARK: ViewModel에서 Keyboard hide 전달 받기
        viewModel.bgTouchedDriver
            .drive(onNext: { [weak self] isTouch in
                self?.wifiReConnectView.endEditing(true)
            })
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

        // MARK: ViewModel로 부터 Keyboard Visible 값 전달 받기
        viewModel.keyboardVisible
            .subscribe(onNext: { [weak self] isVisible in
                if isVisible {
                    self?.handleKeyboardWillShow()
                } else {
                    self?.handleKeyboardWillHide()
                }
            })
            .disposed(by: disposeBag)
    }

    //MARK: 키보드 세팅
    private func setupKeyboardNotifications() {
        // 키보드 나타나는 이벤트 처리
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .map { _ in } // Void로 변환하여 ViewModel로 전달
            .bind(to: viewModel.keyboardWillShow)
            .disposed(by: disposeBag)

        // 키보드 숨김 이벤트 처리
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .map { _ in } // Void로 변환하여 ViewModel로 전달
            .bind(to: viewModel.keyboardWillHide)
            .disposed(by: disposeBag)
    }

    // MARK: 키보드 보일 때 처리
    private func handleKeyboardWillShow() {
        wifiReConnectView.pwStackView.snp.remakeConstraints {
            $0.leading.trailing.equalToSuperview().inset(31)
            $0.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).offset(-49)
        }

        wifiReConnectView.photoImageView.snp.remakeConstraints {
            $0.leading.trailing.equalToSuperview().inset(31)
            $0.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).offset(-250)
            $0.height.equalTo(216)
        }

        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
            self.wifiReConnectView.labelStackView.alpha = 0
            self.wifiReConnectView.cameraButton.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.wifiReConnectView.labelStackView.isHidden = true
        })
    }

    // MARK: 키보드 숨길 때 처리
    private func handleKeyboardWillHide() {
        resetViewState()

        wifiReConnectView.pwStackView.snp.remakeConstraints {
            $0.leading.trailing.equalToSuperview().inset(31)
            $0.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).offset(-187)
        }

        wifiReConnectView.photoImageView.snp.remakeConstraints {
            $0.leading.trailing.equalToSuperview().inset(31)
            $0.bottom.equalTo(self.wifiReConnectView.ssidStackView.snp.top).offset(-53)
            $0.height.equalTo(216)
        }

        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
            self.wifiReConnectView.labelStackView.alpha = 1
            self.wifiReConnectView.cameraButton.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.wifiReConnectView.labelStackView.isHidden = false
        })
    }

    // MARK: 원래 화면으로 복원
    private func resetViewState() {
        wifiReConnectView.labelStackView.alpha = 1
        wifiReConnectView.labelStackView.isHidden = false

        wifiReConnectView.ssidLabel.textColor = .neutral200

        wifiReConnectView.ssidField.textColor = .neutral200
        wifiReConnectView.ssidField.layer.borderColor = UIColor.clear.cgColor
        wifiReConnectView.ssidField.layer.borderWidth = 0

        wifiReConnectView.pwLabel.textColor = .neutral200

        wifiReConnectView.pwField.textColor = .neutral200
        wifiReConnectView.pwField.layer.borderColor = UIColor.clear.cgColor
        wifiReConnectView.pwField.layer.borderWidth = 0
    }

    // MARK: 키보드 deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
