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
        setupNavigationBar()
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

        // ReConnect 버튼을 눌렀을 때 텍스트 필드의 현재 값을 즉시 가져와서 전달
        wifiReConnectView.reConnectButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                // 현재 텍스트 필드 값 가져오기
                let currentSSID = self.wifiReConnectView.ssidField.text ?? ""
                let currentPassword = self.wifiReConnectView.pwField.text ?? ""

                // 현재 이미지 가져오기
                let currentImage = self.wifiReConnectView.photoImageView.image ?? UIImage()

                // ViewModel에 값 반영
                viewModel.ssidText.accept(currentSSID)
                viewModel.pwText.accept(currentPassword)
                viewModel.photoImage.accept(currentImage)

                // ViewModel의 버튼 탭 이벤트 트리거
                viewModel.reConnectButtonTapped.accept(())
            })
            .disposed(by: disposeBag)

        // 카메라 버튼
        wifiReConnectView.cameraButton.rx.tap
            .bind(to: viewModel.cameraButtonTapped)
            .disposed(by: disposeBag)

        // ViewModel로부터 SSID 및 비밀번호 값 받기
        viewModel.ssidDriver
            .drive{ [weak self] ssid in
                self?.wifiReConnectView.ssidField.text = ssid
            }
            .disposed(by: disposeBag)

        viewModel.passwordDriver
            .drive{ [weak self] pw in
                self?.wifiReConnectView.pwField.text = pw
            }
            .disposed(by: disposeBag)

        // 이미지를 받아서 이미지 뷰에 설정
        viewModel.updatedImageDriver
            .drive { [weak self] image in
                self?.wifiReConnectView.photoImageView.image = image
            }
            .disposed(by: disposeBag)
    }


    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = wifiReConnectView.barItem
        navigationItem.rightBarButtonItem?.customView?.frame = CGRect(x: 0, y: 300, width: 26, height: 26)
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


