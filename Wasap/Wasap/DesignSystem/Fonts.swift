//
//  Fonts.swift
//  Wasap
//
//  Created by Chang Jonghyeon on 10/18/24.
//

import UIKit

public struct FontProperty {
    let font: UIFont.FontType
    let size: CGFloat
    let lineHeightMultiple: CGFloat? // 행간(%를 소수로 입력)
    let letterSpacingMultiiple: CGFloat // 자간(%를 소수로 입력)
}

/// 폰트 적용 방법
///
/// ```
/// lazy var titleLabel: UILabel = {
///     let label = UILabel()
///     label.text = "SCAN"
///     label.textColor = .textPrimaryHigh
///     label.font = FontStyle.title.font
///     label.addLabelSpacing(fontStyle: FontStyle.title)
///     return label
/// }()
/// ```
///
public enum FontStyle {
    case title
    case subTitle
    case caption
    case button
    case password_M
    case password_S

    public var fontProperty: FontProperty {
        switch self {
        case .title:
            return FontProperty(font: .gmarketSansBold, size: 26, lineHeightMultiple: 1.0, letterSpacingMultiiple: 0)
        case .subTitle:
            return FontProperty(font: .gmarketSansMedium, size: 16, lineHeightMultiple: 1.0, letterSpacingMultiiple: 0)
        case .caption:
            return FontProperty(font: .gmarketSansMedium, size: 12, lineHeightMultiple: 1.0, letterSpacingMultiiple: 0)
        case .button:
            return FontProperty(font: .gmarketSansMedium, size: 16, lineHeightMultiple: 1.0, letterSpacingMultiiple: 0)
        case .password_M:
            return FontProperty(font: .robotoMonoMedium, size: 20, lineHeightMultiple: 1.0, letterSpacingMultiiple: 0.24)
        case .password_S:
            return FontProperty(font: .robotoMonoRegular, size: 18, lineHeightMultiple: 1.0, letterSpacingMultiiple: 0.24)

        }
    }
}

public extension FontStyle {
    var font: UIFont {
        guard let font = UIFont(name: fontProperty.font.name, size: fontProperty.size) else {
            return UIFont()
        }
        return font
    }
}

extension UIFont {
    enum FontType: String {
        case gmarketSansBold = "GmarketSansBold"
        case gmarketSansMedium = "GmarketSansMedium"
        case robotoMonoMedium = "RobotoMono-Medium"
        case robotoMonoRegular = "RobotoMono-Regular"

        var name: String {
            return self.rawValue
        }

        static func font(_ type: FontType, ofsize size: CGFloat) -> UIFont {
            return UIFont(name: type.rawValue, size: size)!
        }
    }
}


extension UILabel {
    func addLabelSpacing(fontStyle: FontStyle) {
        let lineHeightMultiple = fontStyle.fontProperty.lineHeightMultiple ?? 1.0
        let letterSpacing = fontStyle.fontProperty.letterSpacingMultiiple * font.pointSize

        if let labelText = text, !labelText.isEmpty {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = lineHeightMultiple
            paragraphStyle.alignment = .center

            attributedText = NSAttributedString(
                string: labelText,
                attributes: [
                    .kern: letterSpacing,
                    .paragraphStyle: paragraphStyle
                ]
            )
        }
    }
}
