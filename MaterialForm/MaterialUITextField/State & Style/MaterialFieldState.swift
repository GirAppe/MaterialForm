import UIKit

// MARK: - Field State

public protocol MaterialFieldState: class {
    var fieldState: FieldControlState { get }
    var isShowingError: Bool { get }
    var isEnabled: Bool { get }
    var isDisabled: Bool { get }
}

public extension MaterialFieldState {
    var isDisabled: Bool { return !isEnabled }
}
