//
//  Gradient.swift
//  Wasap
//
//  Created by chongin on 10/9/24.
//

import UIKit

enum Gradients {
    static var gradientBackground1: CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.blue200.cgColor, UIColor.black.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.opacity = 0.5
        return gradient
    }

    static var gradientBackground2: CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.green200.cgColor, UIColor.black.cgColor]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.opacity = 0.22
        return gradient
    }
}


/// gradient 사용 방법
///
/// ```
/// lazy var backgroundView: UIView = {
///     let view = GradientBackgroundView()
///     return view
/// }()
///
/// ...
///
/// self.addSubView(backgroundView)
///
///
/// ...
///
/// backgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }
/// ```
///
/// 주의! 절대로 backgroundView에 addSubView하지 말 것! 여기 위에 올리면 불투명하게 보이니 조심!!
class GradientBackgroundView: UIView, CAAnimationDelegate {

    override func draw(_ rect: CGRect) {
        let gradient1 = Gradients.gradientBackground1
        gradient1.frame = self.bounds


        let gradient2 = Gradients.gradientBackground2
        gradient2.frame = self.bounds

        self.layer.addSublayer(gradient1)
        self.layer.addSublayer(gradient2)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.backgroundColor = UIColor.gray500
    }
}
