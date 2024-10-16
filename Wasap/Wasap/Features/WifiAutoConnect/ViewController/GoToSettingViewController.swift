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
            .drive { [ weak self] ssid in
                self?.goToSettingView.ssidFieldLabel.text = ssid
            }
            .disposed(by: disposeBag)

        viewModel.passwordDriver
            .drive { [ weak self] password in
                self?.goToSettingView.pwFieldLabel.text = password
            }
            .disposed(by: disposeBag)

        viewModel.updatedImageDriver
            .drive { [weak self] image in
                self?.goToSettingView.photoImageView.image = image
            }
            .disposed(by: disposeBag)
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = goToSettingView.barItem
        navigationItem.rightBarButtonItem?.customView?.frame = CGRect(x: 0, y: 300, width: 26, height: 26)
    }
}


