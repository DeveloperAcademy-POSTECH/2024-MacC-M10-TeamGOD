//
//  GoToSettingViewController.swift
//  Wasap
//
//  Created by 김상준 on 10/15/24.
//

import UIKit
import RxSwift
import SnapKit

public class GoToSettingViewController: RxBaseViewController<GoToSettingViewModel>{

    private let goToSettingView = GoToSettingView()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActions()
    }

    public override func loadView() {
        super.loadView()
        self.view = goToSettingView

    }

    override init(viewModel: GoToSettingViewModel) {
        super.init(viewModel: viewModel)
        bind(viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind(_ viewModel: GoToSettingViewModel) {
        goToSettingView.settingBtn.rx.tap
            .bind(to: viewModel.setButtonTapped)
            .disposed(by: disposeBag)

        goToSettingView.xButton.rx.tap
            .bind(to: viewModel.xButtonTapped)
            .disposed(by: disposeBag)

        Observable.just(())
            .bind(to: viewModel.viewDidLoad)
            .disposed(by: disposeBag)

        viewModel.ssidDriver
            .drive(goToSettingView.ssidFieldLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.passwordDriver
            .drive(goToSettingView.pwFieldLabel.rx.text)
            .disposed(by: disposeBag)

    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = goToSettingView.barItem
        navigationItem.rightBarButtonItem?.customView?.frame = CGRect(x: 0, y: 300, width: 26, height: 26)
    }

    private func setupActions() {
        goToSettingView.settingBtn.addTarget(self, action: #selector(copyPassword), for: .touchUpInside)
        goToSettingView.xButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }

    // MARK: - Action
    @objc private func closeButtonTapped() {
        // 버튼 클릭 시 처리할 로직
        print("Close button tapped")
        dismiss(animated: true, completion: nil) // 현재 화면 닫기
    }

    @objc func copyPassword() {
        guard let password = goToSettingView.pwFieldLabel.text, !password.isEmpty else {
            print("비밀번호가 없습니다.")
            return
        }
        UIPasteboard.general.string = password
        print("비밀번호가 복사되었습니다: \(password)")
    }
}


