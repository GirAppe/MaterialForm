import Foundation

// MARK: - Control Event

@available(iOS 10, *)
@objc public enum FieldTriggerEvent: Int {
    case none
    case tap
    case rightAccessoryTap
    case leftAccessoryTap
    case clear
    case returnTap
    case beginEditing
    case endEditing

    public var description: String {
        switch self {
        case .none: return "none"
        case .tap: return "tap"
        case .rightAccessoryTap: return "rightAccessoryTap"
        case .leftAccessoryTap: return "leftAccessoryTap"
        case .clear: return "clear"
        case .returnTap: return "returnTap"
        case .beginEditing: return "beginEditing"
        case .endEditing: return "endEditing"
        }
    }
}
