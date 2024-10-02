//
//  UIView+.swift
//  Wasap
//
//  Created by chongin on 10/3/24.
//


import UIKit

extension UIView {
    func addSubViews(_ views: UIView ...) {
        views.forEach { view in
            self.addSubview(view)
        }
    }
}