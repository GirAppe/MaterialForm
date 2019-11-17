#if canImport(UIKit)

import UIKit

// MARK: - Update State Cycle

@available(iOS 10, *)
extension MaterialUITextField {

    public func update(animated: Bool = true) {
        guard isBuilt else { return }

        let animated = overrideAnimated ?? animated
        defer { overrideAnimated = nil }

        super.placeholder = nil
        super.borderStyle = .none

        defaultStyle?.focusedColor = tintColor
        placeholderLabel.font = placeholderLabel.font.withSize(fontSize)

        infoLabel.errorValue = errorMessage
        infoLabel.infoValue = infoMessage

        mainContainerLeft.constant = insets.left
        mainContainerRight.constant = -insets.right
        mainContainerTop.constant = topPadding + insets.top
        mainContainerBottom.constant = -insets.bottom

        setNeedsDisplay()
        setNeedsLayout()

        animateFloatingLabel(animated: animated)
        animateColors(animated: animated)

        bezelView.set(state: self, style: style)
        infoLabel.set(state: self, style: style)
        backgroundView.set(state: self, style: style)

        infoLabel.update(animated: animated)
        bezelView.update(animated: animated)
        backgroundView.update(animated: animated)

        updateAccessory()

        infoAccessory.isHidden = !showCharactersCounter || maxCharactersCount <= 0
        infoAccessory.textColor = infoLabel.textColor
        infoAccessory.font = infoLabel.font
        updateCharactersCount()

        line.underAccessory = extendLineUnderAccessory || styleType == .roundedRect
    }

    func updateStyleType() {
        switch styleType {
        case .bezel:        style = Style.bezel
        case .line:         style = Style.line
        case .none:         style = Style.none
        case .roundedRect:  style = Style.rounded
        @unknown default:   style = Style.rounded
        }

        if let defaultStyle = self.defaultStyle {
            setIfPossible(&defaultStyle.defaultColor, to: textColor)
            setIfPossible(&defaultStyle.defaultPlaceholderColor, to: textColor)
            setIfPossible(&defaultStyle.backgroundColor, to: superBackgroundColor)
            setIfPossible(&defaultStyle.focusedColor, to: tintColor)
        }

        update(animated: false)
    }

    func updateLineViewHeight() {
        lineViewHeight?.constant = style.maxLineWidth
    }

    func updateCornerRadius() {
        backgroundView.update(animated: true)
        layer.cornerRadius = style.cornerRadius
    }

    func updateAccessory() {
        let left = style.left(accessory: leftAccessory, for: self)
        leftAccessoryView.isHidden = left.isHidden
        leftInputAccessory?.isHidden = left.isHidden
        leftInputAccessory?.tintColor = left.tintColor

        let right = style.right(accessory: rightAccessory, for: self)
        rightAccessoryView.isHidden = right.isHidden
        rightInputAccessory?.isHidden = right.isHidden
        rightInputAccessory?.tintColor = right.tintColor

        setupDebug()
    }

    func animateFloatingLabel(animated: Bool = true) {
        let up = fieldState == .focused || fieldState == .filled

        guard placeholderScaleMultiplier > 0 else {
            return floatingLabel.isHidden = up
        }

        floatingLabel.textColor = style.textColor(for: self)

        let finalTranform: CGAffineTransform = {
            guard up else { return CGAffineTransform.identity }

            let left = -floatingLabel.bounds.width / 2
            let top = -floatingLabel.bounds.height / 2
            let bottom = ((insets.top + topPadding) / 2 + mainContainer.spacing) / placeholderScaleMultiplier

            let moveToZero = CGAffineTransform(translationX: left, y: top)
            let scale = moveToZero.scaledBy(x: placeholderScaleMultiplier, y: placeholderScaleMultiplier)
            return scale.translatedBy(x: -left, y: bottom)
        }()

        guard animated else {
            return floatingLabel.transform = finalTranform
        }

        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: damping,
            initialSpringVelocity: 0,
            options: curve.asOptions,
            animations: {
                self.floatingLabel.transform = finalTranform
            })
    }

    func animateColors(animated: Bool) {
        let lineWidth = style.lineWidth(for: self)
        let lineColor = style.lineColor(for: self)

        line.animateStateChange(animate: animated) { it in
            it.width = lineWidth
            it.color = lineColor
        }

        placeholderLabel.animateStateChange(animate: animated) { it in
            it.textColor = self.style.placeholderColor(for: self)
        }
    }

    func updateCharactersCount() {
        infoAccessory.text = "\(text?.count ?? 0)/\(maxCharactersCount)"
    }

    public func updateFieldState() {
        guard !isEditing else { return }
        guard fieldState == .empty || fieldState == .filled else { return }
        overrideAnimated = false
        fieldState = !(text ?? "").isEmpty ? .filled : .empty
    }

    @objc func updateText() {
        // Makes text edited observable
        text = nil ?? text
        field.text = text ?? placeholder ?? "-"
        field.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
        layoutSubviews()
    }

    @objc func preventImplicitAnimations() {
        UIView.performWithoutAnimation {
            layoutSubviews()
            layoutIfNeeded()
        }
    }
}

#endif
