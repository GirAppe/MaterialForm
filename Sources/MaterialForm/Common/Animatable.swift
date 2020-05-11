#if canImport(UIKit)

import UIKit

/// Adopt this protocol for wrapping state change animations.
protocol Animatable {}

// MARK: - Animatable UIView

extension UIView: Animatable {}

extension Animatable where Self: UIView {

    func animateStateChange(
        animate: Bool,
        with duration: TimeInterval = 0.3,
        _ change: @escaping (Self) -> Void
    )  {
        let animation = {
            change(self)
        }

        guard animate else { return animation() }

        UIView.animate(withDuration: duration, animations: animation)
    }
}

#endif
