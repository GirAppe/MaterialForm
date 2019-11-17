#if os(iOS) || os(tvOS)

import UIKit

@available(iOS 10, *)
public class KeyboardView: UIView {

    // MARK: - Properties

    private var height: NSLayoutConstraint!

    // MARK: - Lifecycle

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setup() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(KeyboardView.keyboardChangeFrame(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(KeyboardView.keyboardChangeFrame(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        self.backgroundColor = UIColor.clear

        height = heightAnchor.constraint(equalToConstant: 0)
        height.isActive = true
        backgroundColor = .clear
    }

    @objc func keyboardChangeFrame(notification: NSNotification) {
        guard let superview = self.superview else { return }
        guard let userInfo = notification.userInfo else { return }
        guard let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard let curveIntValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else { return }
        guard let curve = UIView.AnimationCurve(rawValue: curveIntValue) else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        let keyboardEndFrame = superview.convert(frame, to: nil)
        var height = keyboardEndFrame.height
        let convertedFrame = superview.convert(superview.frame, to: UIApplication.shared.windows[0])
        if convertedFrame.intersection(keyboardEndFrame).height == 0 { height = 0 }

        self.height.constant = height

        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()

        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationCurve(curve)
        UIView.setAnimationBeginsFromCurrentState(true)

        superview.layoutIfNeeded()
        UIView.commitAnimations()
    }
}

#endif
