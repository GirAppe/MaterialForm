#if canImport(UIKit)

import UIKit

// MARK: - Field State

@available(iOS 10, *)
public protocol MaterialFieldState: class {
    var fieldState: FieldControlState { get }
    var isShowingError: Bool { get }
    var isEnabled: Bool { get }
    var isDisabled: Bool { get }
}

@available(iOS 10, *)
public extension MaterialFieldState {
    var isDisabled: Bool { return !isEnabled }
}

#endif
