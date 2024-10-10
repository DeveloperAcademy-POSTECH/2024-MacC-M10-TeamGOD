//
//  WifiConnectView.swift
//  Wasap
//
//  Created by 김상준 on 10/6/24.
//
import UIKit
import SnapKit

class WifiReConnectView: UIView {
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        
        // SF Symbol에서 느낌표가 포함된 아이콘을 설정 (느낌표 아이콘)
        imageView.image = UIImage(systemName: "exclamationmark.circle")
        imageView.tintColor = .black // 아이콘 색상 설정
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .gray // 배경색 설정
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Retry"
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 26) // 텍스트 크기를 26으로 설정
        label.backgroundColor = .yellow
        return label
    }()
    
    lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    lazy var subLabel: UILabel = {
        let label = UILabel()
        label.text = "잘못된 부분이 있나봐요!"
        label.textColor = .black
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
        //        imageView.image = UIImage(named: "wifi")
        return imageView
    }()
    
    lazy var ssidLabel: UILabel = {
        let label = UILabel()
        label.text = "와이파이 ID"
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    lazy var ssidField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a number"
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
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    lazy var pwField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a number"
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
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
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
        self.addSubViews(labelStackView,photoImageView,ssidStackView,pwStackView,reConnectButton)
    }
    
    func setConstraints() {
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(26) // 아이콘 크기를 26으로 설정
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(100)
        }
        
        photoImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(titleStackView.snp.bottom).offset(49)
            $0.height.equalTo(220)
        }
        
        ssidStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(photoImageView.snp.bottom).offset(50)
        }
        pwStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(ssidStackView.snp.bottom).offset(10)
        }
        reConnectButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(pwStackView.snp.bottom).offset(62)
            $0.width.equalTo(ssidStackView)
        }
    }
}
