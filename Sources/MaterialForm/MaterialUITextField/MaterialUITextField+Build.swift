#if os(iOS) || os(tvOS)

import UIKit

// MARK: - Build UI Phase

@available(iOS 10, *)
extension MaterialUITextField {

    var isInViewHierarchy: Bool {
        return self.window != nil
    }

    func build() {
        guard isInViewHierarchy else { return }

        buildContainer()
        buildInnerField()
        buildRightAccessory()
        buildLeftAccessory()
        buildLine()
        buildBezel()
        buildBackground()
        buildFloatingLabel()
        buildInfoLabel()
        setupDebug()

        // Setup
        super.delegate = self
        mainContainer.isUserInteractionEnabled = false
        fieldContainer.isUserInteractionEnabled = false
        lineContainer.isUserInteractionEnabled = false
        placeholderLabel.isUserInteractionEnabled = false

        isBuilt = true
        update(animated: false)
    }

    func buildContainer() {
        addSubview(mainContainer.clear())

        mainContainerTop = mainContainer.topAnchor.constraint(equalTo: topAnchor)
        mainContainerLeft = mainContainer.leftAnchor.constraint(equalTo: leftAnchor)
        mainContainerRight = mainContainer.rightAnchor.constraint(equalTo: rightAnchor)
        mainContainerBottom = mainContainer.bottomAnchor.constraint(equalTo: bottomAnchor)

        NSLayoutConstraint.activate([
            mainContainerTop,
            mainContainerLeft,
            mainContainerRight,
            mainContainerBottom
        ])
    }

    func buildInnerField() {
        mainContainer.addArrangedSubview(fieldContainer.clear())

        fieldContainer.addArrangedSubview(leftAccessoryView.clear())
        fieldContainer.addArrangedSubview(field.clear())
        fieldContainer.addArrangedSubview(rightAccessoryView.clear())

        leftAccessoryView.setContentHuggingPriority(.required, for: .horizontal)
        rightAccessoryView.setContentHuggingPriority(.required, for: .horizontal)

        let fieldHeight = field.heightAnchor.constraint(equalToConstant: fontSize)
        fieldHeight.priority = .defaultLow
        fieldHeight.isActive = true
    }

    func buildFloatingLabel() {
        addSubview(floatingLabel.clear())
        bringSubviewToFront(floatingLabel)
        floatingLabel.isUserInteractionEnabled = false

        NSLayoutConstraint.activate([
            floatingLabel.topAnchor.constraint(equalTo: topAnchor),
            floatingLabel.leftAnchor.constraint(equalTo: field.leftAnchor),
            floatingLabel.bottomAnchor.constraint(equalTo: lineContainer.topAnchor),
            floatingLabel.rightAnchor.constraint(lessThanOrEqualTo: field.rightAnchor)
        ])
    }

    func buildLine() {
        // Container setup
        lineContainer.clear()
        lineContainer = UIView()
        lineContainer.translatesAutoresizingMaskIntoConstraints = false
        lineContainer.backgroundColor = .clear
        lineContainer.clipsToBounds = false
        mainContainer.addArrangedSubview(lineContainer)

        // Container height
        lineViewHeight = lineContainer.heightAnchor.constraint(equalToConstant: style.maxLineWidth)
        lineViewHeight?.isActive = true

        // Adding actual line
        line = UnderlyingLineView()
        line.translatesAutoresizingMaskIntoConstraints = false
        lineContainer.addSubview(line.clear())

        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: lineContainer.topAnchor),
            line.leftAnchor.constraint(equalTo: leftAnchor),
            line.rightAnchor.constraint(equalTo: rightAnchor)
        ])

        line.buildAsUnderline(for: field)

        // Set initial values
        line.color = style.lineColor(for: self)
        line.width = style.lineWidth(for: self)
        line.underAccessory = extendLineUnderAccessory || styleType == .roundedRect
    }

    func buildBezel() {
        bezelView.isUserInteractionEnabled = false
        bezelView.backgroundColor = .clear
        addSubview(bezelView.clear())
        sendSubviewToBack(bezelView)

        NSLayoutConstraint.activate([
            bezelView.topAnchor.constraint(equalTo: topAnchor),
            bezelView.leftAnchor.constraint(equalTo: leftAnchor),
            bezelView.rightAnchor.constraint(equalTo: rightAnchor),
            bezelView.bottomAnchor.constraint(equalTo: lineContainer.bottomAnchor)
        ])
    }

    func buildBackground() {
        backgroundView.isUserInteractionEnabled = false
        backgroundView.clipsToBounds = true
        addSubview(backgroundView.clear())
        sendSubviewToBack(backgroundView)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: lineContainer.topAnchor)
        ])
    }

    func buildInfoLabel() {
        mainContainer.addArrangedSubview(infoContainer.clear())
        infoContainer.addArrangedSubview(infoLabel)
        infoContainer.addArrangedSubview(infoAccessory)
        infoAccessory.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        infoAccessory.setContentCompressionResistancePriority(.required, for: .horizontal)
        infoLabel.set(state: self, style: style)
        infoLabel.build()
        infoAccessory.backgroundColor = .clear
    }

    #if DEBUG
    func setupDebug() {
        guard isDebuggingViewHierarchy else { return }
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.green.withAlphaComponent(0.5).cgColor
        floatingLabel.layer.borderWidth = 1
        floatingLabel.layer.borderColor = UIColor.blue.withAlphaComponent(0.5).cgColor
        leftView?.layer.borderWidth = 1
        leftView?.layer.borderColor = UIColor.magenta.withAlphaComponent(0.5).cgColor
        leftAccessoryView.layer.borderWidth = 1
        leftAccessoryView.layer.borderColor = UIColor.cyan.withAlphaComponent(0.5).cgColor
        rightView?.layer.borderWidth = 1
        rightView?.layer.borderColor = UIColor.magenta.withAlphaComponent(0.5).cgColor
        rightAccessoryView.layer.borderWidth = 1
        rightAccessoryView.layer.borderColor = UIColor.cyan.withAlphaComponent(0.5).cgColor
    }
    #else
    func setupDebug() {}
    #endif
}

#endif
