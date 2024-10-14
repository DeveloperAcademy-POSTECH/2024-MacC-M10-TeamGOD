//
//  ConnectingView.swift
//  Wasap
//
//  Created by Chang Jonghyeon on 10/14/24.
//

import UIKit
import SnapKit
import Lottie

class ConnectingView: BaseView {
    lazy var backgroundView: UIView = {
        let view = GradientBackgroundView()
        return view
    }()
    
    lazy var quitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "QuitButtonDefault"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    lazy var doneSignIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "DoneIcon"))
        icon.isHidden = true
        return icon
    }()
    
    lazy var mainStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "ASAP!"
        label.textColor = .neutralWhite
        label.font = .systemFont(ofSize: 26, weight: .bold)
        return label
    }()
    
    lazy var subStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "연결중"
        label.textColor = .neutralWhite
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    lazy var statusStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainStatusLabel, subStatusLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var loadingAnimation: LottieAnimationView = {
        let animation = LottieAnimationView(name: "finding")
        animation.loopMode = .loop
        animation.play()
        return animation
    }()
    
    func setViewHierarchy() {
        self.addSubview(backgroundView)
        self.addSubViews(loadingAnimation, statusStackView, doneSignIcon, quitButton)
    }
    
    func setConstraints() {
        backgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        quitButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(71)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        statusStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(359)
        }
        
        doneSignIcon.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(statusStackView.snp.top).offset(-10)
        }
        
        loadingAnimation.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(statusStackView.snp.bottom).offset(-230)
        }
    }
}
