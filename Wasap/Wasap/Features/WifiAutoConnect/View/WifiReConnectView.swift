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

        textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        textField.addTarget(self, action: #selector(ssidFieldSelected), for: .editingDidBegin)
        
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
        
        textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        textField.addTarget(self, action: #selector(pwFieldSelected), for: .editingDidBegin)
        
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
        setupKeyboardNotifications()
        setupTapGesture()
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
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(108)
        }
        
        photoImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(31)
            $0.top.equalTo(labelStackView.snp.bottom).offset(50)
            $0.height.equalTo(216)
        }
        
        ssidStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(31)
            $0.top.equalTo(photoImageView.snp.bottom).offset(54)
        }
        
        ssidField.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalToSuperview()
        }
        pwStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(31)
            $0.top.equalTo(ssidStackView.snp.bottom).offset(16)
        }
        
        pwField.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalToSuperview()
        }
        
        reConnectButton.snp.makeConstraints {
            $0.top.equalTo(pwStackView.snp.bottom).offset(54)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 키보드 숨기기
        resetViewState() // 초기 상태로 복구
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
        return true
    }
    
    @objc private func textFieldValueChanged() {
        // ssidField 또는 pwField 값이 변경되었는지 확인
        let ssid : String = ""
        let pw : String = ""

        if ssidField.text != ssid || pwField.text != pw {
            reConnectButton.backgroundColor = .green200  // 값이 변경되면 버튼 색 변경
            reConnectButton.setTitle("다시 연결하기", for: .normal)
            reConnectButton.setTitleColor(.black, for: .normal)
            
            reConnectButton.layer.borderWidth = 1
            reConnectButton.layer.borderColor = UIColor.clear.cgColor
        } else {
            reConnectButton.backgroundColor = .clear  // 원래 색상으로 복원
        }
    }
    
    
    @objc private func ssidFieldSelected() {
        ssidLabel.textColor = .green200
        ssidField.textColor = .green200
        ssidField.layer.borderColor = UIColor.green200.cgColor
        ssidField.layer.borderWidth = 1
        
        pwLabel.textColor = .neutral200
        pwField.textColor = .neutral200
        pwField.layer.borderColor = UIColor.neutral200.cgColor
        pwField.layer.borderWidth = 0
    }
    
    @objc private func pwFieldSelected() {
        pwLabel.textColor = .green200
        pwField.textColor = .green200
        pwField.layer.borderColor = UIColor.green200.cgColor
        pwField.layer.borderWidth = 1
        
        ssidLabel.textColor = .neutral200
        ssidField.textColor = .neutral200
        ssidField.layer.borderColor = UIColor.neutral200.cgColor
        ssidField.layer.borderWidth = 0
        
    }

    private var isKeyboardVisible = false  // 키보드가 현재 보이는 상태인지 추적

    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        print("open")

        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.labelStackView.alpha = 0
            self.cameraButton.alpha = 0
            self.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight / 2)
        }, completion: { _ in
            self.labelStackView.isHidden = true
        })
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        resetViewState()
        self.cameraButton.alpha = 1
        print("close")

        // 올라간 화면 원상 복구
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.layoutIfNeeded()
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    private func resetViewState() {
        labelStackView.alpha = 1
        labelStackView.isHidden = false
        
        ssidLabel.textColor = .neutral200
        ssidField.textColor = .neutral200
        ssidField.layer.borderColor = UIColor.clear.cgColor
        ssidField.layer.borderWidth = 0
        
        pwLabel.textColor = .neutral200
        pwField.textColor = .neutral200
        pwField.layer.borderColor = UIColor.clear.cgColor
        pwField.layer.borderWidth = 0
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        self.endEditing(true) // 키보드 숨기기
        resetViewState() // 초기 상태로 복구
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
