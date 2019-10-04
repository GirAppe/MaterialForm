//
//  MaterialFieldState.swift
//  MaterialForm
//
//  Created by Andrzej Michnia on 04/10/2019.
//  Copyright © 2019 MakeAWishFoundation. All rights reserved.
//

import UIKit

// MARK: - MaterialFieldState

public protocol MaterialFieldState: class {
    var fieldState: FieldControlState { get }
    var isShowingError: Bool { get }
    var isEnabled: Bool { get }
    var isDisabled: Bool { get }
}

public extension MaterialFieldState {
    var isDisabled: Bool { return !isEnabled }
}
