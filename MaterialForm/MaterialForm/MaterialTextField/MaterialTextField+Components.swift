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

        weak var field: MaterialFieldState?
        var animationDuration: TimeInterval = 0.36

        func build() {
            minHeight = heightAnchor.constraint(greaterThanOrEqualToConstant: font.lineHeight)
            let c = heightAnchor.constraint(equalToConstant: font.lineHeight + 4)
            c.priority = .defaultLow
            c.isActive = true
            minHeight.isActive = true
        }

        func update(style: MaterialTextFieldStyle, animated: Bool) {
            guard let field = field else { return }

            self.text = field.isShowingError ? errorValue : infoValue

            animateStateChange(animate: animated, duration: animationDuration) { it in
                it.textColor = style.infoColor(for: field)
            }
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

        func maskByRoundingCorners(_ masks: UIRectCorner) {
            let rounded = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: masks,
                cornerRadii: CGSize(width: layer.cornerRadius, height: layer.cornerRadius)
            )

            let shape = CAShapeLayer()
            shape.path = rounded.cgPath

            self.layer.masksToBounds = true
            self.layer.mask = shape
        }
    }

    // MARK: - Bezel View

    internal class BezelView: UIView {

        var state: MaterialFieldState?
        var style: MaterialTextFieldStyle?

        func update(animated: Bool) {
            backgroundColor = .clear

            guard let state = state, let style = style else { return }

            animateStateChange(animate: animated) { it in
                it.layer.borderColor = style.borderColor(for: state).cgColor
                it.layer.borderWidth = style.borderWidth(for: state)
                it.layer.cornerRadius = style.cornerRadius
            }
        }
    }
}
