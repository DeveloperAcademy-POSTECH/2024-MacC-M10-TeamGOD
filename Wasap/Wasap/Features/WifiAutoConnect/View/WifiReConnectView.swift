//
//  WifiConnectView.swift
//  Wasap
//
//  Created by 김상준 on 10/6/24.
//
import UIKit
import SnapKit

class WifiReConnectView: BaseView {
    
    private var selectedSSIDField : Bool = false
    private var selectedPasswordField : Bool = false
    
    private var reconnectButtonBottomConstraint: Constraint?
    
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
        textField.placeholder = "Enter a number"
        textField.backgroundColor = UIColor(red: 66/255, green: 66/255, blue: 70/255, alpha: 1)
        textField.textColor = .white
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.font = .preferredFont(forTextStyle: .headline)
        textField.returnKeyType = .done
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
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
        textField.placeholder = "Enter a number"
        textField.backgroundColor = UIColor(red: 66/255, green: 66/255, blue: 70/255, alpha: 1)
        textField.textColor = .white
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.font = .preferredFont(forTextStyle: .headline)
        textField.returnKeyType = .done
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
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
    
    lazy var upButton: UIButton = {
        let button = UIButton()
        button.setTitle("업", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 25
        button.isHidden = true // 초기 값 히든
        button.addTarget(self, action: #selector(ssidFieldSelected), for: .touchUpInside)
        return button
    }()
    
    lazy var downButton: UIButton = {
        let button = UIButton()
        button.setTitle("다운", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .green
        button.isHidden = true // 초기 값 히든
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(pwFieldSelected), for: .touchUpInside)
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
        
        backgroundView.addSubview(labelStackView)
        backgroundView.addSubview(photoImageView)
        backgroundView.addSubview(ssidStackView)
        backgroundView.addSubview(pwStackView)
        backgroundView.addSubview(reConnectButton)
        
        backgroundView.addSubview(upButton)
        backgroundView.addSubview(downButton)
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
            $0.top.equalTo(labelStackView.snp.bottom).offset(20)
            $0.height.equalTo(220)
        }
        
        ssidStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(photoImageView.snp.bottom).offset(30)
        }
        
        ssidField.snp.makeConstraints {
            $0.height.equalTo(62)
            $0.width.equalToSuperview()
        }
        pwStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(ssidStackView.snp.bottom).offset(30)
        }
        
        pwField.snp.makeConstraints {
            $0.height.equalTo(62)
            $0.width.equalToSuperview()  // 고정 너비 설정
        }
        
        reConnectButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(84)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
            $0.width.equalTo(353)
        }
        
        upButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(84)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(52)
            $0.height.equalTo(52)
        }
        
        downButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(84)
            $0.leading.equalTo(upButton.snp.trailing).offset(10)
            
            $0.width.equalTo(52)
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
    
    @objc private func ssidFieldSelected() {
        // 비밀번호 필드와 라벨 스택뷰를 숨김
        pwStackView.isHidden = true
        labelStackView.isHidden = true
//        
//        selectedSSIDField = true
//        selectedPasswordField = false

        // 애니메이션으로 텍스트 필드 이동
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: { [self] in
            self.ssidStackView.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.top.equalTo(photoImageView.snp.bottom).offset(30)
            }
            self.layoutIfNeeded() // 레이아웃 즉시 반영
        })
    }

    @objc private func pwFieldSelected() {
        // SSID 필드와 라벨 스택뷰를 숨김
        ssidStackView.isHidden = true
        labelStackView.isHidden = true
        
//        selectedSSIDField = false
//        selectedPasswordField = true

        // 애니메이션으로 텍스트 필드 이동
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: { [self] in
            self.pwStackView.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.top.equalTo(photoImageView.snp.bottom).offset(30)
            }
            self.layoutIfNeeded() // 레이아웃 즉시 반영
        })
    }
    
    // 업 버튼 액션: 이전 필드로 이동 (SSID -> 비밀번호)
        @objc private func buttonTapped() {
            if (selectedSSIDField && !selectedPasswordField) {
                pwField.becomeFirstResponder()
            } else if (!selectedSSIDField && selectedPasswordField) {
                ssidField.becomeFirstResponder()
            }
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
        
        upButton.isHidden = false
        downButton.isHidden = false
        
        upButton.alpha = 0
        downButton.alpha = 0
        reConnectButton.alpha = 0
        
        // 버튼 위치를 키보드 위에 배치
        upButton.snp.remakeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().inset(keyboardHeight - 50)
            $0.width.equalTo(52)
            $0.height.equalTo(52)
        }
        downButton.snp.remakeConstraints {
            $0.leading.equalTo(upButton.snp.trailing).offset(10)
            $0.bottom.equalToSuperview().inset(keyboardHeight - 50)
            $0.width.equalTo(52)
            $0.height.equalTo(52)
        }
        reConnectButton.snp.remakeConstraints {
            $0.leading.equalTo(downButton.snp.trailing).offset(10)
            $0.bottom.equalToSuperview().inset(keyboardHeight - 50)
            $0.width.equalTo(353) // 동일한 너비 설정
            $0.height.equalTo(52)
        }
        
        // 애니메이션으로 뷰와 버튼을 자연스럽게 표시
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            self.upButton.alpha = 1
            self.downButton.alpha = 1
            self.reConnectButton.alpha = 1
            
            self.layoutIfNeeded() // 레이아웃을 즉시 반영
            self.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight / 4)
        }, completion: nil)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        // 모든 필드와 스택 뷰를 다시 표시
        ssidStackView.isHidden = false
        labelStackView.isHidden = false

        // 애니메이션으로 SSID 필드를 부드럽게 표시
        ssidStackView.alpha = 0  // 처음에 투명하게 설정
        resetViewState()
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.ssidStackView.alpha = 1  // 페이드 인
            self.ssidStackView.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.top.equalTo(self.photoImageView.snp.bottom).offset(30)
            }
            self.layoutIfNeeded()  // 레이아웃 즉시 반영
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }

    
    
    private func resetViewState() {
        // 모든 필드를 보이도록 설정하고 초기 상태로 복구
        labelStackView.isHidden = false
        ssidStackView.isHidden = false
        pwStackView.isHidden = false
        
        upButton.isHidden = true
        downButton.isHidden = true
        
        // 초기 레이아웃 제약 조건 설정
        ssidStackView.snp.remakeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(photoImageView.snp.bottom).offset(30)
        }
        
        pwStackView.snp.remakeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(ssidStackView.snp.bottom).offset(30)
        }
        
        reConnectButton.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(84)
            $0.width.equalTo(ssidStackView)
            $0.height.equalTo(52)
        }
        
        // 애니메이션을 추가하여 복구 시 자연스럽게 전환
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
            self.layoutIfNeeded() // 레이아웃 반영
        })
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
