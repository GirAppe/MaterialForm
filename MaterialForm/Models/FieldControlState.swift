import Foundation

// MARK: - Control State

@objc public enum FieldControlState: Int, CaseIterable {
    case empty
    case focused
    case filled

    public var description: String {
        switch self {
        case .empty: return "empty"
        case .focused: return "focused"
        case .filled: return "filled"
        }
    }
}
