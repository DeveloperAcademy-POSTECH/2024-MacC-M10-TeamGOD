//
//  WifiReConnectView.swift
//  Wasap
//
//  Created by 김상준 on 10/6/24.
//
import UIKit
import SnapKit

class WifiReConnectView: BaseView {

    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkBackground
        return view
    }()

    // MARK: NAVIGATION BAR BTN
    lazy var cameraButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "GoCameraButton"), for: .normal)
        return button
    }()

    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "RetryViewIcon")
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
        stackView.spacing = 3
        return stackView
    }()

    lazy var subLabel: UILabel = {
        let label = UILabel()
        label.text = "잘못된 부분이 있나봐요!"
        label.textColor = .neutral400
        label.font = UIFont.systemFont(ofSize: 16)
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
        imageView.image = UIImage(named: "RetryViewPhoto")
        imageView.layer.borderColor = UIColor.green200.cgColor
        imageView.layer.borderWidth = 3.0
        return imageView
    }()

    lazy var ssidLabel: UILabel = {
        let label = UILabel()
        label.text = "와이파이 ID"
        label.textColor = .neutral200
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    lazy var ssidField: UITextField = {
        let textField = UITextField()
        textField.textColor = .neutral200
        textField.backgroundColor = .neutral450
        textField.font = .preferredFont(forTextStyle: .headline)
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.textAlignment = .center

        return textField
    }()

    lazy var ssidStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ssidLabel, ssidField])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    lazy var pwLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = .neutral200
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    lazy var pwField: UITextField = {
        let textField = UITextField()
        textField.textColor = .neutral200
        textField.backgroundColor = .neutral450
        textField.font = .preferredFont(forTextStyle: .headline)
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.textAlignment = .center

        return textField
    }()

    lazy var pwStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pwLabel, pwField])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    lazy var reConnectButton: UIButton = {
        let button = UIButton()
        button.setTitle("다시 연결하기", for: .normal)
        button.setTitleColor(.neutral200, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.neutral200.cgColor
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
                                   reConnectButton,cameraButton)
    }

    func setConstraints() {
        backgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }

        cameraButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(68)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(32)
            $0.height.equalTo(32)
        }

        iconImageView.snp.makeConstraints { $0.width.height.equalTo(26) }

        reConnectButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-82)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }

        pwStackView.snp.makeConstraints {
            $0.width.equalTo(330)
            $0.leading.trailing.equalToSuperview().inset(31)
            $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-187) // - 30 (키보드 레이아웃 가이드)
        }

        pwField.snp.makeConstraints {
            $0.height.equalTo(62)
            $0.width.equalTo(330)
        }

        ssidStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(31)
            $0.bottom.equalTo(pwStackView.snp.top).offset(-16)
        }

        ssidField.snp.makeConstraints {
            $0.height.equalTo(62)
            $0.width.equalTo(330)
        }

        photoImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(31)
            $0.bottom.equalTo(ssidStackView.snp.top).offset(-53)
            $0.height.equalTo(216)
        }

        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalTo(photoImageView.snp.top).offset(-53)
        }
    }
}
