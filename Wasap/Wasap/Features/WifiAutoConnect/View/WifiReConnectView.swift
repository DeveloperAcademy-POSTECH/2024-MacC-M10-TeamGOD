//
//  WifiConnectView.swift
//  Wasap
//
//  Created by 김상준 on 10/6/24.
//
import UIKit
import SnapKit

class WifiReConnectView: BaseView {
    
    let ssid : String = "KT_GIGA_5G_B67C"
    let pw : String  = "dd08ff7107"
    
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
        stackView.spacing = 8
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
        textField.text = ssid
        textField.backgroundColor = UIColor(red: 66/255, green: 66/255, blue: 70/255, alpha: 1)
        textField.textColor = .white
        textField.font = .preferredFont(forTextStyle: .headline)
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.textAlignment = .center
        
        textField.addTarget(self, action: #selector(ssidFieldSelected), for: .editingDidBegin)
        
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
        textField.text = pw
        textField.backgroundColor = UIColor(red: 66/255, green: 66/255, blue: 70/255, alpha: 1)
        textField.textColor = .white
        textField.font = .preferredFont(forTextStyle: .headline)
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.textAlignment = .center
        
        textField.addTarget(self, action: #selector(pwFieldSelected), for: .editingDidBegin)
        
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
            $0.height.equalTo(220)
        }
        
        ssidStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(photoImageView.snp.bottom).offset(53)
        }
        
        ssidField.snp.makeConstraints {
            $0.height.equalTo(62)
            $0.width.equalToSuperview()
        }
        pwStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(ssidStackView.snp.bottom).offset(16)
        }
        
        pwField.snp.makeConstraints {
            $0.height.equalTo(62)
            $0.width.equalToSuperview()
        }
        
        reConnectButton.snp.makeConstraints {
            $0.top.equalTo(pwStackView.snp.bottom).offset(53)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
            $0.width.equalTo(353)
        }
    }
    
    
    // 레이아웃이 완료된 후 초기 값을 설정
    override func layoutSubviews() {
        super.layoutSubviews()
        ssidField.text = ssid
        pwField.text = pw
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 키보드 숨기기
        resetViewState() // 초기 상태로 복구
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
        return true
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
            self.layoutIfNeeded() // 레이아웃을 즉시 반영
            self.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight / 2)
        }, completion: { _ in
            self.labelStackView.isHidden = true
        })
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        resetViewState()
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
        ssidField.layer.borderColor = UIColor.neutral200.cgColor
        ssidField.layer.borderWidth = 0
        
        pwLabel.textColor = .neutral200
        pwField.textColor = .neutral200
        pwField.layer.borderColor = UIColor.neutral200.cgColor
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
