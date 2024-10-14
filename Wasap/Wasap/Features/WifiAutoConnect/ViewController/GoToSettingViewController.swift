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
    }
    
    public override func loadView() {
        super.loadView()
        self.view = goToSettingView
        setupActions()
    }
    
    override init(viewModel: GoToSettingViewModel) {
        super.init(viewModel: viewModel)
        bind(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(_ viewModel: GoToSettingViewModel) {
        
    }
    
    private func setupActions() {
           goToSettingView.settingBtn.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
           goToSettingView.ssidField.addTarget(self, action: #selector(ssidFieldSelected), for: .editingDidBegin)
           goToSettingView.pwField.addTarget(self, action: #selector(pwFieldSelected), for: .editingDidBegin)
        goToSettingView.ssidField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        goToSettingView.pwField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        
        
        goToSettingView.settingBtn.addTarget(self, action: #selector(copyPassword), for: .touchUpInside)
       }
    
    @objc func openSettings() {
        if let settingsURL = URL(string: "App-Prefs:") {
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            } else {
                print("설정 앱을 열 수 없습니다.")
            }
        }
    }
    
    @objc func copyPassword() {
        guard let password = goToSettingView.pwField.text, !password.isEmpty else {
            print("비밀번호가 없습니다.")
            return
        }
        
        UIPasteboard.general.string = password
        print("비밀번호가 복사되었습니다: \(password)")
    }
    
    @objc private func ssidFieldSelected() {
        goToSettingView.ssidLabel.textColor = .green200
        goToSettingView.ssidField.textColor = .green200
        goToSettingView.ssidField.layer.borderColor = UIColor.green200.cgColor
        goToSettingView.ssidField.layer.borderWidth = 1
        
        goToSettingView.pwLabel.textColor = .neutral200
        goToSettingView.pwField.textColor = .neutral200
        goToSettingView.pwField.layer.borderColor = UIColor.neutral200.cgColor
        goToSettingView.pwField.layer.borderWidth = 0
    }
    
    @objc private func pwFieldSelected() {
        goToSettingView.pwLabel.textColor = .green200
        goToSettingView.pwField.textColor = .green200
        goToSettingView.pwField.layer.borderColor = UIColor.green200.cgColor
        goToSettingView.pwField.layer.borderWidth = 1
        
        goToSettingView.ssidLabel.textColor = .neutral200
        goToSettingView.ssidField.textColor = .neutral200
        goToSettingView.ssidField.layer.borderColor = UIColor.neutral200.cgColor
        goToSettingView.ssidField.layer.borderWidth = 0
        
    }
    
    @objc private func textFieldValueChanged() {
        // ssidField 또는 pwField 값이 변경되었는지 확인
        let ssid : String = "KT_GIGA_5G_B67C"
        let pw : String  = "dd08ff7107"
        
        if goToSettingView.ssidField.text != ssid || goToSettingView.pwField.text != pw {
            goToSettingView.settingBtn.backgroundColor = .green200  // 값이 변경되면 버튼 색 변경
            goToSettingView.settingBtn.setTitle("다시 연결하기", for: .normal)
            goToSettingView.settingBtn.setTitleColor(.black, for: .normal)
        } else {
            goToSettingView.settingBtn.backgroundColor = .clear  // 원래 색상으로 복원
        }
    }
    
}


