import UIKit

internal var isDebuggingViewHierarchy = false
private let buttonTag = 321823

// MARK: - Main Implementation

open class MaterialTextField: UITextField, MaterialField {

    // MARK: - Configuration

    /// Makes intrinsic content size being at least X in height.
    /// Defaults to 64 (recommended 44 + some buffer for the placeholder),
    /// since it is nice number because of being power of 2
    @IBInspectable open var minimumHeight: CGFloat = 64 { didSet { update() } }

    @IBInspectable open var placeholderPointSize: CGFloat = 11 { didSet { update() } }

    @IBInspectable open var extendLineUnderAccessory: Bool = true { didSet { update() } }

    open var animationDuration: Float = 0.36
    open var animationCurve: String? {
        didSet { curve = AnimationCurve(name: animationCurve) ?? curve }
    }
    open var animationDamping: Float = 1

    @IBInspectable open var radius: CGFloat = 4 { didSet { backgroundView.setup(radius: radius) } }
    open var insets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 0, right: 12) {
        didSet { update(animated: false) }
    }

    private var duration: TimeInterval { return TimeInterval(animationDuration) }
    private var curve: AnimationCurve = .easeInOut
    private var damping: CGFloat { return CGFloat(animationDamping) }

    // MARK: - Error handling

    public var isShowingError: Bool { return infoLabel.errorValue != nil }

    public var errorMessage: String? { didSet { update() } }
    @IBInspectable public var infoMessage: String? { didSet { update() } }

    // MARK: - Style

    var style: MaterialTextFieldStyle = DefaultMaterialTextFieldStyle() { didSet { update() } }
    private var defaultStyle: DefaultMaterialTextFieldStyle? { return style as? DefaultMaterialTextFieldStyle }

    // MARK: - Observable properties

    @objc dynamic internal(set) public var event: FieldTriggerEvent = .none
    @objc dynamic internal(set) public var fieldState: FieldControlState = .empty

    // MARK: - Overrides

    open override var intrinsicContentSize: CGSize {
        var maxHeight = textRect(forBounds: bounds).height
        maxHeight += insets.top
        maxHeight += topPadding
        maxHeight += bottomPadding
        maxHeight += insets.bottom
        return super.intrinsicContentSize
            .constrainedTo(maxHeight: maxHeight)
            .constrainedTo(minHeight: minimumHeight)
    }
    open override var placeholder: String? {
        get { return floatingLabel.text }
        set { floatingLabel.text = newValue }
    }
    open override var font: UIFont? { willSet { field.font = newValue } }
    open override var tintColor: UIColor! { didSet { update() } }
    open override var backgroundColor: UIColor? {
        get { return backgroundView.backgroundColor }
        set { backgroundView.backgroundColor = newValue }
    }

    @available(*, unavailable, message: "Not supported yet")
    open override var adjustsFontSizeToFitWidth: Bool {
        get { return false }
        set { }
    }

    open override var leftView: UIView? {
        get { return rightInputAccessory }
        set { rightInputAccessory = newValue }
    }
    open override var rightView: UIView?  {
       get { return rightInputAccessory }
       set { rightInputAccessory = newValue }
   }

    open override var delegate: UITextFieldDelegate? {
        get { return proxyDelegate }
        set { proxyDelegate = newValue }
    }
    internal weak var proxyDelegate: UITextFieldDelegate? = nil

    // MARK: - Inner structure

    private let mainContainer: UIStackView = {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .vertical
        container.alignment = .fill
        container.spacing = 4
        container.isUserInteractionEnabled = true
        return container
    }()
    private let fieldContainer: UIStackView = {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .horizontal
        container.alignment = .fill
        container.spacing = 8
        container.isUserInteractionEnabled = true
        return container
    }()

    private var mainContainerTop: NSLayoutConstraint!
    private var mainContainerLeft: NSLayoutConstraint!
    private var mainContainerRight: NSLayoutConstraint!
    private var mainContainerBottom: NSLayoutConstraint!

    private let field: UnderlyingField = UnderlyingField()

    // MARK: - Right Accessory

    @available(*, unavailable, message: "Only for IB. Use `set(rightIcon:for:)` instead")
    @IBInspectable public var rightIcon: UIImage? { willSet { rightIconFromIB = newValue } }
    public func set(rightIcon icon: UIImage?, for state: UIControl.State) {
        let rightButton = rightInputAccessory?.asAccessoryButton ?? buildRightAccessoryButton()
        rightButton.setImage(icon, for: state)
    }

    private var rightIconFromIB: UIImage?
    private let rightAccessoryView = UIView()
    private var rightInputAccessory: UIView? {
        didSet { oldValue?.clear(); buildRightAccessory(); update() }
    }

    // MARK: - Left Accessory

    @available(*, unavailable, message: "Only for IB. Use `set(leftIcon:for:)` instead")
    @IBInspectable public var leftIcon: UIImage? { willSet { leftIconFromIB = newValue } }
    public func set(leftIcon icon: UIImage?, for state: UIControl.State) {
        let button = leftInputAccessory?.asAccessoryButton ?? buildLeftAccessoryButton()
        button.setImage(icon, for: state)
    }
    private var leftIconFromIB: UIImage?
    private let leftAccessoryView = UIView()
    private var leftInputAccessory: UIView? {
        didSet { oldValue?.clear(); buildLeftAccessory(); update() }
    }

    // MARK: - Placeholder label

    public var placeholderLabel: UILabel { return floatingLabel }
    private let floatingLabel = UILabel()

    private var topPadding: CGFloat {
        return floatingLabel.font.lineHeight * placeholderScaleMultiplier
    }
    private var bottomPadding: CGFloat {
        return infoLabel.bounds.height + lineContainer.bounds.height + mainContainer.spacing * 2
    }

    // MARK: - Underline container

    private var lineContainer = UIView()
    private var lineViewHeight: NSLayoutConstraint?
    private var line = UnderlyingLineView()

    // MARK: - Background View

    private let backgroundView = BackgroundView()

    // MARK: - Info view

    public let infoLabel = InfoLabel()
    private let infoContainer: UIStackView = {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .horizontal
        container.alignment = .fill
        container.spacing = 4
        container.isUserInteractionEnabled = true
        return container
    }()
    private let infoAccessory = InfoLabel()

    // MARK: - Properties

    var observations: [Any] = []
    private var isBuilt: Bool = false

    public var placeholderAdjustment: CGFloat = 0.9

    var placeholderScaleMultiplier: CGFloat { return placeholderPointSize / fontSize * placeholderAdjustment }
    var fontSize: CGFloat { return font?.pointSize ?? 17 }

    // MARK: - Lifecycle

    private lazy var buildOnce: () -> Void = {
        setup()
        build()
        setup(with: style)
        setupPostBuild()
        setupObservers()
        return {}
    }()

    open override func layoutSubviews() {
        buildOnce(); super.layoutSubviews()
    }

    // MARK: - Area

    private var rectLeftPadding: CGFloat {
        guard let width = leftInputAccessory?.bounds.width else { return 0 }
        return width + fieldContainer.spacing
    }

    private var rectRightPadding: CGFloat {
        guard let width = rightInputAccessory?.bounds.width else { return 0 }
        return width + fieldContainer.spacing
    }

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        let base = super.textRect(forBounds: bounds)
        let textInsets = UIEdgeInsets(
            top: topPadding + insets.top,
            left: rectLeftPadding + insets.left,
            bottom: bottomPadding + insets.bottom,
            right: rectRightPadding + insets.right
        )
        return base.inset(by: textInsets)
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let base = super.editingRect(forBounds: bounds)
        let textInsets = UIEdgeInsets(
            top: topPadding + insets.top,
            left: rectLeftPadding + insets.left,
            bottom: bottomPadding + insets.bottom,
            right: rectRightPadding + insets.right
        )
        return base.inset(by: textInsets)
    }

    open override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var base = super.clearButtonRect(forBounds: bounds)
        base = base.offsetBy(dx: -rectRightPadding - insets.right, dy: -base.minY - base.height / 2)
        base = base.offsetBy(dx: 0, dy: backgroundView.bounds.height / 2 )
        return base
    }

    open override func caretRect(for position: UITextPosition) -> CGRect {
        return super.caretRect(for: position).insetBy(dx: 0, dy: fontSize * 0.12)
    }

    // MARK: - Setup

    private func setup() {
        placeholder = super.placeholder
        super.placeholder = nil
        super.borderStyle = .none
        super.adjustsFontSizeToFitWidth = false
        field.adjustsFontSizeToFitWidth = false

        super.rightView = nil
        super.leftView = nil
        rightAccessoryView.backgroundColor = .clear
        leftAccessoryView.backgroundColor = .clear

        defaultStyle?.backgroundColor = super.backgroundColor ?? defaultStyle?.backgroundColor ?? .clear
        super.backgroundColor = .clear

        placeholderLabel.font = font ?? placeholderLabel.font

        if let color = textColor {
            defaultStyle?.defaultColor = color
            defaultStyle?.defaultPlaceholderColor = color
        }

        field.font = font
        field.textColor = .clear
        field.text = placeholder ?? "-"
        field.backgroundColor = .clear
        field.isUserInteractionEnabled = false

        infoLabel.font = (font ?? infoLabel.font)?.withSize(11)
        infoLabel.lineBreakMode = .byTruncatingTail
        infoLabel.numberOfLines = 1

        defaultStyle?.focusedColor = tintColor
    }

    private func setup(with style: MaterialTextFieldStyle) {
        switch style {
        case let style as DefaultMaterialTextFieldStyle:
            backgroundColor = style.backgroundColor
            backgroundView.isHidden = false
        // TODO: Plain
        // TODO: Rounded
        default:
            return
        }
    }

    private func setupPostBuild() {
        if let rightIcon = rightIconFromIB {
            set(rightIcon: rightIcon, for: .normal)
        }
        if let leftIcon = leftIconFromIB {
            set(leftIcon: leftIcon, for: .normal)
        }
    }

    private func setupObservers() {
        observations = [
            observe(\.fieldState) { it, _ in it.update(animated: true) }
        ]
        addTarget(self, action: #selector(updateText), for: .editingChanged)
    }
}

// MARK: - Update

private extension MaterialTextField {

    func update(animated: Bool = true) {
        guard isBuilt else { return }

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
        infoLabel.update(style: style, animated: animated)
    }

    func updateLineViewHeight() {
        lineViewHeight?.constant = style.maxLineWidth
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

        backgroundView.animateStateChange(animate: animated) { it in
            it.backgroundColor = self.style.backgroundColor(for: self)
            it.setup(radius: self.radius)
        }

        placeholderLabel
        // TODO: Implement text field and placeholder colors
    }

    @objc func updateText() {
        // Makes text edited observable
        let text = self.text
        self.text = text
        field.text = text ?? placeholder ?? "-"
        field.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
        layoutSubviews()
    }
}

// MARK: - Build UI Phase

private extension MaterialTextField {

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
            floatingLabel.rightAnchor.constraint(equalTo: field.rightAnchor),
            floatingLabel.bottomAnchor.constraint(equalTo: lineContainer.topAnchor)
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
        line.underAccessory = extendLineUnderAccessory
    }

    func buildBackground() {
//        guard isBuilt else { return }
//        guard superview != nil else { return }

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

        infoLabel.field = self
        infoLabel.build()
    }

    func setupDebug() {
        guard isDebuggingViewHierarchy else { return }
        #if DEBUG
        layer.borderWidth = 1
        layer.borderColor = UIColor.red.cgColor
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.green.cgColor
        floatingLabel.layer.borderWidth = 1
        floatingLabel.layer.borderColor = UIColor.blue.cgColor
        #endif
    }
}

// MARK: - Accessories build & Action

extension MaterialTextField {

    func buildRightAccessory() {
        rightInputAccessory?.clear()
        rightAccessoryView.subviews.forEach { $0.removeFromSuperview() }

        guard let accessory = rightInputAccessory else {
            return rightAccessoryView.isHidden = true
        }

        addSubview(accessory.clear())
        accessory.setContentCompressionResistancePriority(.required, for: .horizontal)
        let compress = accessory.widthAnchor.constraint(equalToConstant: 0)
        compress.priority = .required - 1
        compress.isActive = true

        NSLayoutConstraint.activate([
            accessory.leftAnchor.constraint(equalTo: rightAccessoryView.leftAnchor),
            accessory.rightAnchor.constraint(equalTo: rightAccessoryView.rightAnchor),
            accessory.heightAnchor.constraint(equalTo: rightAccessoryView.heightAnchor),
            accessory.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        ])

        rightAccessoryView.isHidden = false
    }

    func buildRightAccessoryButton() -> UIButton {
        rightInputAccessory = nil
        rightAccessoryView.isHidden = false
        let button = buildAccessoryButton(in: rightAccessoryView)
        button.addTarget(self, action: #selector(didTapRightAccessory), for: .touchUpInside)
        rightInputAccessory = button
        return button
    }

    func buildLeftAccessory() {
        leftInputAccessory?.clear()
        leftAccessoryView.subviews.forEach { $0.removeFromSuperview() }

        guard let accessory = leftInputAccessory else {
            return leftAccessoryView.isHidden = true
        }

        addSubview(accessory.clear())
        accessory.setContentCompressionResistancePriority(.required, for: .horizontal)
        let compress = accessory.widthAnchor.constraint(equalToConstant: 0)
        compress.priority = .required - 1
        compress.isActive = true

        NSLayoutConstraint.activate([
            accessory.leftAnchor.constraint(equalTo: leftAccessoryView.leftAnchor),
            accessory.rightAnchor.constraint(equalTo: leftAccessoryView.rightAnchor),
            accessory.heightAnchor.constraint(equalTo: leftAccessoryView.heightAnchor),
            accessory.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        ])

        leftAccessoryView.isHidden = false
    }

    func buildLeftAccessoryButton() -> UIButton {
        leftInputAccessory = nil
        leftAccessoryView.isHidden = false
        let button = buildAccessoryButton(in: leftAccessoryView)
        button.addTarget(self, action: #selector(didTapLeftAccessory), for: .touchUpInside)
        leftInputAccessory = button
        return button
    }

    func buildAccessoryButton(in accessory: UIView) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = buttonTag

//        addSubview(button)
//
//        NSLayoutConstraint.activate([
//            button.widthAnchor.constraint(equalTo: button.heightAnchor),
//            button.leftAnchor.constraint(equalTo: accessory.leftAnchor),
//            button.rightAnchor.constraint(equalTo: accessory.rightAnchor),
//            button.heightAnchor.constraint(equalTo: accessory.heightAnchor),
//            button.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
//        ])

        return button
    }

    @objc func didTapRightAccessory() {
        event = .rightAccessoryTap
    }

    @objc func didTapLeftAccessory() {
        event = .leftAccessoryTap
    }
}

extension UIView {
    var asAccessoryButton: UIButton? {
        guard self.tag == buttonTag else { return nil }
        return self as? UIButton
    }
}
