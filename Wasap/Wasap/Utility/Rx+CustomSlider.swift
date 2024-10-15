//
//  Rx+CustomSlider.swift
//  Wasap
//
//  Created by chongin on 10/15/24.
//

import RxSwift
import RxCocoa

extension Reactive where Base: CustomSlider {
    public var currentSteppedValue: ControlProperty<Float> {
        return controlProperty(editingEvents: [.allEditingEvents, .valueChanged]) { slider in
            slider.currentSteppedValue
        } setter: { slider, value in
            slider.currentSteppedValue = value
        }
    }
}
