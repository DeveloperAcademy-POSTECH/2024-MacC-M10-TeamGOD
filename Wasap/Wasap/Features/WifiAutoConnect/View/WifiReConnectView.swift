//
//  WifiConnectView.swift
//  Wasap
//
//  Created by 김상준 on 10/6/24.
//

import UIKit
import SnapKit

class WifiReConnectView: BaseView {
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray500
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "exclamationmark.circle")
        imageView.tintColor = .primary200
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Retry"
        label.textColor = .primary200
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 26)
        return label
    }()
    
    lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8 // 적절한 간격 부여
        return stackView
    }()
    
    lazy var subLabel: UILabel = {
        let label = UILabel()
        label.text = "잘못된 부분이 있나봐요!"
        label.textColor = .neutral400
        label.textAlignment = .left
        return label
    }()
    
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleStackView, subLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.backgroundColor = .gray500
        imageView.layer.borderColor = UIColor.green200.cgColor
        imageView.layer.borderWidth = 3.0
        return imageView
    }()
    
    lazy var ssidLabel: UILabel = {
        let label = UILabel()
        label.text = "와이파이 ID"
        label.textColor = .neutral200
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var ssidField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a number"
        textField.backgroundColor = UIColor(red: 66/255, green: 66/255, blue: 70/255, alpha: 1)
        textField.textColor = .white
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.font = .preferredFont(forTextStyle: .headline)
        textField.returnKeyType = .done
        return textField
    }()
    
    lazy var ssidStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ssidLabel, ssidField])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var pwLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = .neutral200
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var pwField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a number"
        textField.backgroundColor = UIColor(red: 66/255, green: 66/255, blue: 70/255, alpha: 1)
        textField.textColor = .white
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.font = .preferredFont(forTextStyle: .headline)
        textField.returnKeyType = .done
        return textField
    }()
    
    lazy var pwStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pwLabel, pwField])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var reConnectButton: UIButton = {
        let button = UIButton()
        button.setTitle("다시 연결하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray200.cgColor
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewHierarchy() {
        self.addSubview(backgroundView)
        
        backgroundView.addSubview(labelStackView)
        backgroundView.addSubview(photoImageView)
        backgroundView.addSubview(ssidStackView)
        backgroundView.addSubview(pwStackView)
        backgroundView.addSubview(reConnectButton)
    }
    
    func setConstraints() {
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(26)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(100)
        }
        
        photoImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(labelStackView.snp.bottom).offset(20)
            $0.height.equalTo(220)
        }
        
        ssidStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(photoImageView.snp.bottom).offset(30)
        }
        
        ssidField.snp.makeConstraints {
            $0.height.equalTo(62)
        }
        
        pwStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(ssidStackView.snp.bottom).offset(30)
        }
        
        pwField.snp.makeConstraints {
            $0.height.equalTo(62)
        }
        
        reConnectButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(pwStackView.snp.bottom).offset(77)
            $0.width.equalTo(ssidStackView)
            $0.height.equalTo(52)
        }
    }
}
