#if canImport(UIKit)

import UIKit

extension MaterialUITextField {

    // MARK: - Context actions accessors

    @IBInspectable var isPasteEnabled: Bool {
        get { self.isEnabled(.paste) }
        set { self.setEnabled(.paste, newValue) }
    }

    @IBInspectable var isSelectEnabled: Bool {
        get { self.isEnabled(.select) }
        set { self.setEnabled(.select, newValue) }
    }

    @IBInspectable var isSelectAllEnabled: Bool {
        get { self.isEnabled(.selectAll) }
        set { self.setEnabled(.selectAll, newValue) }
    }

    @IBInspectable var isCopyEnabled: Bool {
        get { self.isEnabled(.copy) }
        set { self.setEnabled(.copy, newValue) }
    }

    @IBInspectable var isCutEnabled: Bool {
        get { self.isEnabled(.cut) }
        set { self.setEnabled(.cut, newValue) }
    }

    @IBInspectable var isDeleteEnabled: Bool {
        get { self.isEnabled(.delete) }
        set { self.setEnabled(.delete, newValue) }
    }

    // MARK: - Context action\

    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action {
        case #selector(UIResponderStandardEditActions.paste(_:)) where !isPasteEnabled,
             #selector(UIResponderStandardEditActions.select(_:)) where !isSelectEnabled,
             #selector(UIResponderStandardEditActions.selectAll(_:)) where !isSelectAllEnabled,
             #selector(UIResponderStandardEditActions.copy(_:)) where !isCopyEnabled,
             #selector(UIResponderStandardEditActions.cut(_:)) where !isCutEnabled,
             #selector(UIResponderStandardEditActions.delete(_:)) where !isDeleteEnabled:
            return false
        default:
            return super.canPerformAction(action, withSender: sender)
        }
    }

    // MARK: - Private

    private func isEnabled(_ action: MaterialFieldContextAction) -> Bool {
        allowedContextActions.contains(action)
    }

    private func isDisabled(_ action: MaterialFieldContextAction) -> Bool {
        !self.isEnabled(action)
    }

    private func setEnabled(_ action: MaterialFieldContextAction, _ enabled: Bool) {
        if enabled, !self.allowedContextActions.contains(action) {
            self.allowedContextActions.append(action)
        }

        if !enabled, self.allowedContextActions.contains(action) {
            self.allowedContextActions.removeAll(where: { $0 ==  action })
        }
    }
}
#endif
