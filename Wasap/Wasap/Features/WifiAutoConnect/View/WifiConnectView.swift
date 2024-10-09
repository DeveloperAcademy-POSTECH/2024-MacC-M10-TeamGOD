//
//  WifiConnectView.swift
//  Wasap
//
//  Created by 김상준 on 10/6/24.
//

import UIKit
import SnapKit


class WifiConnectView: BaseView {
    
    lazy var ssidField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a number"
        textField.font = .preferredFont(forTextStyle: .headline)
        textField.returnKeyType = .done
        return textField
    }()
    
    lazy var pwField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a number"
        textField.font = .preferredFont(forTextStyle: .headline)
        textField.returnKeyType = .done
        return textField
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "와이파이 연결 상태"
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var connectButton: UIButton = {
        let button = UIButton()
        button.setTitle("Connect", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        return button
    }()
    
    func setViewHierarchy() {
        self.addSubViews(ssidField,pwField,statusLabel,connectButton,resetButton)
    }
    
    func setConstraints() {
        
        ssidField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide).offset(50)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        pwField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(ssidField.snp.bottom).offset(50)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        statusLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(pwField.snp.bottom).offset(60)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        connectButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(statusLabel.snp.bottom).offset(50)
            $0.width.equalTo(statusLabel).multipliedBy(1)
        }
        
        resetButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(connectButton.snp.bottom).offset(50)
            $0.width.equalTo(connectButton).multipliedBy(1)
            
        }
    }
}
