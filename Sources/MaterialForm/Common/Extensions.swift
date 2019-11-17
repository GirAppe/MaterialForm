#if canImport(UIKit)

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

    func constrainedTo(maxWidth: CGFloat) -> CGSize {
        return CGSize(width: min(width, maxWidth), height: height)
    }
}

internal extension CGRect {

    func constrainedTo(minHeight: CGFloat) -> CGRect {
        return insetBy(dx: 0, dy: (height - size.constrainedTo(minHeight: minHeight).height) / 2)
    }

    func constrainedTo(maxHeight: CGFloat) -> CGRect {
        return insetBy(dx: 0, dy: (height - size.constrainedTo(maxHeight: maxHeight).height) / 2)
    }

    func constrainedTo(minWidth: CGFloat) -> CGRect {
        return insetBy(dx: (width - size.constrainedTo(minWidth: minWidth).width) / 2, dy: 0)
    }

    func constrainedTo(maxWidth: CGFloat) -> CGRect {
        return insetBy(dx: (width - size.constrainedTo(maxWidth: maxWidth).width) / 2, dy: 0)
    }
}

@available(iOS 10, *)
internal extension UIView {

    @available(iOS 10, *)
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

func setIfPossible<T>(_ lhs: inout T, to value: T?) {
    guard value != nil else { return }
    lhs = value!
}

#endif
