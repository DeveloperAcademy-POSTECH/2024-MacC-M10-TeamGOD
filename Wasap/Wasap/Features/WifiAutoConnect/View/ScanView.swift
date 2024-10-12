//
//  ScanView.swift
//  Wasap
//
//  Created by Chang Jonghyeon on 10/10/24.
//

import UIKit
import SnapKit

class ScanView: BaseView {
    lazy var previewView: UIImageView = {
        let previewView = UIImageView()
        previewView.contentMode = .scaleAspectFit
        return previewView
    }()
    
    lazy var wifiSymbolImage: UIImageView = {
        let wifiSymbolImage = UIImageView(image: UIImage(named: "Wifi_1"))
        return wifiSymbolImage
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ASAP!"
        label.font = .preferredFont(forTextStyle: .headline) // .gmarketSansBold
        return label
    }()
    
    lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "연결 중"
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    lazy var loadingAnimationComponent: UIView = {
        let animationComponent = UIView()
        animationComponent.backgroundColor = .white
        return animationComponent
    }()
    
    func setViewHierarchy() {
        self.addSubViews(previewView, wifiSymbolImage, titleLabel, loadingLabel, loadingAnimationComponent)
    }
    
    func setConstraints() {
        previewView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide).offset(84)
            $0.width.equalTo(340)
            $0.height.equalTo(220)
        }
        
        wifiSymbolImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(previewView.snp.bottom).offset(46)
            $0.width.equalTo(18.39)
            $0.height.equalTo(12.99)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(wifiSymbolImage.snp.bottom).offset(10.01)
        }
        
        loadingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        
        loadingAnimationComponent.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loadingLabel.snp.bottom).offset(7)
            $0.width.equalTo(242)
            $0.height.equalTo(242)
        }
    }
}
