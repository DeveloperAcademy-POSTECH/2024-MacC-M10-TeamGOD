//
//  ImageAnalysisView.swift
//  Wasap
//
//  Created by Chang Jonghyeon on 10/6/24.
//

import UIKit
import SnapKit

class ImageAnalysisTempView: BaseView {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var selectImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("이미지 선택", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var ssidLabel: UILabel = {
        let label = UILabel()
        label.text = "SSID: "
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password: "
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()

    func setViewHierarchy() {
        self.addSubViews(imageView, selectImageButton, ssidLabel, passwordLabel)
    }
    
    func setConstraints() {
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide).offset(20)
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(400)
        }
        
        selectImageButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.height.equalTo(50)
        }
        
        ssidLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(selectImageButton.snp.bottom).offset(20)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(ssidLabel.snp.bottom).offset(10)
        }
    }
}
