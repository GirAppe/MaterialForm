
//
//  Extensions.swift
//  MaterialForm
//
//  Created by Andrzej Michnia on 30/09/2019.
//  Copyright © 2019 MakeAWishFoundation. All rights reserved.
//

import UIKit

internal extension CGSize {

    func constrainedTo(minHeight: CGFloat) -> CGSize {
        return CGSize(width: width, height: max(height, minHeight))
    }

    func constrainedTo(maxHeight: CGFloat) -> CGSize {
        return CGSize(width: width, height: min(height, maxHeight))
    }

    func constrainedTo(minWidth: CGFloat) -> CGSize {
        return CGSize(width: max(width, minWidth), height: height)
    }
}

internal extension UIView {

    @discardableResult func clear() -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        removeFromSuperview()
        subviews.forEach { $0.removeFromSuperview() }
        (self as? UIStackView)?.arrangedSubviews.forEach { $0.removeFromSuperview() }
        return self
    }
}

internal extension Optional where Wrapped: Collection {

    var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }
}

internal extension UIView.AnimationCurve {

    init?(name: String?) {
        switch name {
        case "linar"?:      self = .linear
        case "easeInOut"?:  self = .easeInOut
        case "easeIn"?:     self = .easeIn
        case "easeOut"?:    self = .easeOut
        default:            return nil
        }
    }

    var asOptions: UIView.AnimationOptions  {
        switch self {
        case .linear:       return .curveLinear
        case .easeInOut:    return .curveEaseInOut
        case .easeIn:       return .curveEaseIn
        case .easeOut:      return .curveEaseOut
        @unknown default:   return .curveEaseInOut
        }
    }
}
