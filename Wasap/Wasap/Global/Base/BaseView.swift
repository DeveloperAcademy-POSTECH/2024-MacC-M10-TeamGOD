//
//  Layout.swift
//  Wasap
//
//  Created by chongin on 10/3/24.
//


import UIKit

public protocol Layout {
    func setViewHierarchy()
    func setConstraints()
}

open class BaseViewClass: UIView {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
    }

    override open func layoutSubviews() {
        setLayouts()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setLayouts() {
        guard let baseView = self as? BaseView else { return }

        baseView.setViewHierarchy()
        baseView.setConstraints()
    }
}

typealias BaseView = BaseViewClass & Layout
