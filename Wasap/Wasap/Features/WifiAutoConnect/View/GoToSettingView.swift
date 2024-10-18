//
//  GoToSettingView.swift
//  Wasap
//
//  Created by 김상준 on 10/15/24.
//

import Foundation
import UIKit
import SnapKit

class GoToSettingView: BaseView {
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkBackground
        return view
    }()
    
    // MARK: NAVIGATION BAR BTN
    lazy var xButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "QuitButtonDefault"), for: .normal)
        return button
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SorryViewIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sorry"
        label.textColor = .green300
        label.textAlignment = .left
        label.font = FontStyle.title.font
        label.addLabelSpacing(fontStyle: FontStyle.title)
        return label
    }()

    lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 3
        return stackView
    }()
    
    lazy var subLabel: UILabel = {
        let label = UILabel()
        label.text = "연결 실패"
        label.textColor = .neutral400
        label.font = FontStyle.subTitle.font
        label.addLabelSpacing(fontStyle: FontStyle.subTitle)
        label.textAlignment = .left
        return label
    }()

    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleStackView, subLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        return imageView
    }()
    
    lazy var ssidLabel: UILabel = {
        let label = UILabel()
        label.text = "와이파이 ID"
        label.textColor = .neutral200
//        label.font = FontStyle.caption.font. 
        return label
    }()

    lazy var ssidFieldLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutral200
        // 450 으로 변경 예정
        label.backgroundColor = UIColor
            .neutral450
        label.font = FontStyle.password_M.font
        label.layer.cornerRadius = 13
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.text = "SSID" // 기본 텍스트 설정 (예시)
        return label
    }()

    lazy var ssidStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ssidLabel, ssidFieldLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    lazy var pwLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = .neutral200
        label.font = FontStyle.caption.font
        return label
    }()

    lazy var pwFieldLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutral200
        label.backgroundColor = UIColor
            .neutral450
        label.font = .preferredFont(forTextStyle: .headline)
        label.layer.cornerRadius = 13
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.text = "PW" // 기본 텍스트 설정 (예시)
        return label
    }()

    lazy var pwStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pwLabel, pwFieldLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .gray100
        label.textAlignment = .center

        let wifiID = "와이파이 ID"
        let description = "\(wifiID)가 실제와 다를 수 있어요.\n아래 버튼을 누르면 비밀번호를 복사합니다."
        // 글자 색깔 넣기
        let attributedString = NSMutableAttributedString(string: description)
        if let wifiIDRange = description.range(of: wifiID) {
            let nsRange = NSRange(wifiIDRange, in: description)
            attributedString.addAttribute(.foregroundColor, value: UIColor.primary200, range: nsRange)
        }

        label.attributedText = attributedString
        return label
    }()
    
    lazy var settingBtn: UIButton = {
        let button = UIButton()
        button.setTitle("설정에서 연결하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .primary200
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
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
        backgroundView.addSubViews(labelStackView,photoImageView,
                                   ssidStackView,pwStackView,
                                   settingBtn,infoLabel,xButton)
    }
    
    func setConstraints() {
        backgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }

        xButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(71)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(26)
            $0.height.equalTo(26)
        }

        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(108)
        }
        
        photoImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(62)
            $0.top.equalTo(labelStackView.snp.bottom).offset(50)
            $0.height.equalTo(175)
        }
        
        ssidStackView.snp.makeConstraints {
            $0.top.equalTo(photoImageView.snp.bottom).offset(29)
            $0.leading.trailing.equalToSuperview().inset(63)
        }
        
        ssidFieldLabel.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.width.equalToSuperview()
        }
        
        pwStackView.snp.makeConstraints {
            $0.top.equalTo(ssidStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(63)
        }
        
        pwFieldLabel.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.width.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.top.equalTo(pwStackView.snp.bottom).offset(49)
        }
        
        settingBtn.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(49)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
            $0.width.equalTo(353)
        }
    }
}
