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
    
    // MARK: NAVIGATION BAR BTN
    lazy var cameraButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "GoCameraButton"), for: .normal)
        return button
    }()
    
    lazy var barItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(customView: cameraButton)
        return barButtonItem
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
        stackView.spacing = 4
        return stackView
    }()
    
    lazy var subLabel: UILabel = {
        let label = UILabel()
        label.text = "잘못된 부분이 있나봐요!"
        label.textColor = .gray400
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
        imageView.image = UIImage(named: "RetryViewPhoto")
        imageView.layer.borderColor = UIColor.green200.cgColor
        imageView.layer.borderWidth = 2.0
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
        textField.backgroundColor = UIColor(red: 0.26, green: 0.26, blue: 0.275, alpha: 1)
        textField.font = .preferredFont(forTextStyle: .headline)
        textField.font = UIFont.systemFont(ofSize: 20)
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
        textField.backgroundColor = UIColor(red: 0.26, green: 0.26, blue: 0.275, alpha: 1)
        textField.font = .preferredFont(forTextStyle: .headline)
        textField.font = UIFont.systemFont(ofSize: 20)
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
        button.setTitleColor(UIColor.neutral200, for: .normal)
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
                                   reConnectButton)
    }
    
    func setConstraints() {
        backgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        iconImageView.snp.makeConstraints { $0.width.height.equalTo(26) }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(100)
        }
        
        photoImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(labelStackView.snp.bottom).offset(53)
            $0.height.equalTo(216)
        }
        
        ssidStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(photoImageView.snp.bottom).offset(53)
        }
        
        ssidField.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalToSuperview()
        }
        pwStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(ssidStackView.snp.bottom).offset(16)
        }
        
        pwField.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalToSuperview()
        }
        
        reConnectButton.snp.makeConstraints {
            $0.top.equalTo(pwStackView.snp.bottom).offset(53)
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
        let ssid : String = "KT_GIGA_5G_B67C"
        let pw : String  = "dd08ff7107"
        
        
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
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            self.labelStackView.alpha = 0
            self.barItem.customView?.alpha = 0
            self.layoutIfNeeded() // 레이아웃을 즉시 반영
            self.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight / 2)
        }, completion: { _ in
            self.labelStackView.isHidden = true
        })
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        resetViewState()
        self.barItem.customView?.alpha = 1
        
        // 올라간 화면 원상 복구
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
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
