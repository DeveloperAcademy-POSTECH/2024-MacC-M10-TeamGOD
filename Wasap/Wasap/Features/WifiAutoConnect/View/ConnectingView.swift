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
    
    lazy var mainStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "ASAP!"
        label.textColor = .neutralWhite
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()
    
    lazy var subStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "연결중"
        label.textColor = .neutralWhite
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    lazy var loadingAnimation: LottieAnimationView = {
        let animation = LottieAnimationView(name: "finding")
        animation.loopMode = .loop
        animation.play()
        return animation
    }()
    
    func setViewHierarchy() {
        self.addSubview(backgroundView)
        self.addSubViews(loadingAnimation, mainStatusLabel, subStatusLabel)
        
    }
    
    func setConstraints() {
        backgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        mainStatusLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(359)
        }
        
        subStatusLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(mainStatusLabel.snp.bottom).offset(6)
        }
        
        loadingAnimation.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(subStatusLabel.snp.bottom).offset(-230)
        }
    }
}
