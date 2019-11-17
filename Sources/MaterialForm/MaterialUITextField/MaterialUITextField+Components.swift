#if os(iOS) || os(tvOS)

import UIKit

// MARK: - Components

@available(iOS 10, *)
extension MaterialUITextField {

    // MARK: - Info Label

    public class InfoLabel: UILabel {

        var minHeight: NSLayoutConstraint!
        var infoValue: String?
        var errorValue: String?
        var duration: TimeInterval = 0.36

        weak var state: MaterialFieldState?
        weak var style: MaterialTextFieldStyle?

        func build() {
            minHeight = heightAnchor.constraint(greaterThanOrEqualToConstant: font.lineHeight)
            let c = heightAnchor.constraint(equalToConstant: font.lineHeight + 4)
            c.priority = .defaultLow
            c.isActive = true
            minHeight.isActive = true
        }

        func set(state: MaterialFieldState, style: MaterialTextFieldStyle) {
            self.state = state
            self.style = style
        }

        func update(animated: Bool) {
            guard let state = state, let style = style else { return }

            self.text = state.isShowingError ? errorValue : infoValue

            animateStateChange(animate: animated, with: duration) { it in
                it.textColor = style.infoColor(for: state)
            }
        }
    }

    // MARK: - Background View

    internal class BackgroundView: UIView {

        var duration: TimeInterval = 0.36

        weak var state: MaterialFieldState?
        weak var style: MaterialTextFieldStyle?

        func set(state: MaterialFieldState, style: MaterialTextFieldStyle) {
            self.state = state
            self.style = style
        }

        func update(animated: Bool) {
            guard let state = state, let style = style else { return }

            layer.cornerRadius = style.cornerRadius
            if #available(iOS 11.0, *) {
                layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            } else {
                maskByRoundingCorners([.topLeft, .topRight])
            }

            animateStateChange(animate: animated, with: duration) { it in
                it.backgroundColor = style.backgroundColor(for: state)
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

        var duration: TimeInterval = 0.36

        weak var state: MaterialFieldState?
        weak var style: MaterialTextFieldStyle?

        func set(state: MaterialFieldState, style: MaterialTextFieldStyle) {
            self.state = state
            self.style = style
        }

        func update(animated: Bool) {
            backgroundColor = .clear

            guard let state = state, let style = style else { return }
            
            animateStateChange(animate: animated, with: duration) { it in
                it.layer.borderColor = style.borderColor(for: state).cgColor
                it.layer.borderWidth = style.borderWidth(for: state)
                it.layer.cornerRadius = style.cornerRadius
            }
        }
    }
}

#endif
