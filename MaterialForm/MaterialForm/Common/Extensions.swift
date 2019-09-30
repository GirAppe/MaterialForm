
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

    public var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }
}

