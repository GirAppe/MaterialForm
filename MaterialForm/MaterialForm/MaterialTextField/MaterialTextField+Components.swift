//
//  MaterialTextField+Components.swift
//  MaterialForm
//
//  Created by Andrzej Michnia on 02/10/2019.
//  Copyright © 2019 MakeAWishFoundation. All rights reserved.
//

import UIKit

// MARK: - Components

extension MaterialTextField {

    // MARK: - Info Label

    public class InfoLabel: UILabel {

        var minHeight: NSLayoutConstraint!
        var infoValue: String?
        var errorValue: String?

        weak var field: MaterialField?
        var animationDuration: TimeInterval = 0.36

        func build() {
            minHeight = heightAnchor.constraint(greaterThanOrEqualToConstant: font.lineHeight)
            minHeight.isActive = true
        }

        func update(style: MaterialTextFieldStyle, animated: Bool) {
            guard let field = field else { return }

            self.text = field.isShowingError ? errorValue : infoValue

            let change = { self.textColor = style.infoColor(for: field) }

            guard animated else { return change() }

            UIView.animate(withDuration: animationDuration, animations: change)
        }
    }

    // MARK: - Background View

    internal class BackgroundView: UIView {
        func setup(radius: CGFloat) {
            layer.cornerRadius = radius
            if #available(iOS 11.0, *) {
                layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            } else {
                maskByRoundingCorners([.topLeft, .topRight])
            }
        }

        func maskByRoundingCorners(_ masks: UIRectCorner, withRadii radii:CGSize = CGSize(width: 10, height: 10)) {
            let rounded = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: masks, cornerRadii: radii)

            let shape = CAShapeLayer()
            shape.path = rounded.cgPath

            self.layer.mask = shape
        }
    }
}

