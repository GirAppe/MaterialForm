#if canImport(UIKit)

import UIKit

// MARK: - Default implementation

public protocol ConfigurableTextFieldStyle { }

@available(iOS 10, *)
public extension ConfigurableTextFieldStyle where Self: MaterialTextFieldStyle {

    /// Overrides `MaterialTextFieldStyle` allowing to alter some of its properties.
    /// - Parameter config: Configuration closure (non-escaping)
    func configure(with config: (Self) -> Void) -> Self {
        config(self)
        return self
    }
}
#endif
