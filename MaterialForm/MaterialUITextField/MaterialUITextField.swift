import UIKit

internal var isDebuggingViewHierarchy = false

// MARK: - Main Implementation

open class MaterialUITextField: UITextField, MaterialFieldState {

    // MARK: - Configuration

    @IBOutlet weak var nextField: UITextField?

    /// Makes intrinsic content size being at least X in height.
    /// Defaults to 64 (recommended 44 + some buffer for the placeholder).
    /// And it is a nice number because of being power of 2.
    @IBInspectable open var minimumHeight: CGFloat = 64 { didSet { update() } }
    @IBInspectable open var placeholderPointSize: CGFloat = 11 { didSet { update() } }
    @IBInspectable open var extendLineUnderAccessory: Bool = true { didSet { update() } }

    @IBInspectable open var radius: CGFloat {
        get { return style.cornerRadius }
        set { style.cornerRadius = newValue; updateCornerRadius() }
    }
    open var insets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 0, right: 12) {
        didSet { update(animated: false) }
    }

    open var innerHorizontalSpacing: CGFloat {
        get { return fieldContainer.spacing }
        set { fieldContainer.spacing = newValue; update(animated: false) }
    }
    open var innerVerticalSpacing: CGFloat {
        get { return mainContainer.spacing }
        set { mainContainer.spacing = newValue; update(animated: false) }
    }

    @IBInspectable open var maxCharactersCount: Int = 0 { didSet { update() } }
    @IBInspectable open var isEditingEnabled: Bool = true  { didSet { update() } }
    @IBInspectable open var showCharactersCounter: Bool = false { didSet { update() } }

    // MARK: - Animation Configuration

    open var animationDuration: Float = 0.36
    open var animationCurve: String? {
        didSet { curve = AnimationCurve(name: animationCurve) ?? curve }
    }
    open var animationDamping: Float = 1

    var duration: TimeInterval { return TimeInterval(animationDuration) }
    var curve: AnimationCurve = .easeInOut
    var damping: CGFloat { return CGFloat(animationDamping) }

    // MARK: - Error handling

    public var isShowingError: Bool { return infoLabel.errorValue != nil }

    public var errorMessage: String? { didSet { update() } }
    @IBInspectable public var infoMessage: String? { didSet { update() } }

    // MARK: - Style

    var style: MaterialTextFieldStyle = DefaultMaterialTextFieldStyle() {
        didSet {
            insets = defaultStyle?.insets ?? insets
            update(animated: false)
        }
    }
    var defaultStyle: DefaultMaterialTextFieldStyle? { return style as? DefaultMaterialTextFieldStyle }

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
        set { floatingLabel.text = newValue; update(animated: false) }
    }
    open override var font: UIFont? { willSet { field.font = newValue } }
    open override var tintColor: UIColor! { didSet { update() } }
    open override var backgroundColor: UIColor? {
        get { return backgroundView.backgroundColor }
        set { backgroundView.backgroundColor = newValue }
    }
    private var superBackgroundColor: UIColor?

    @available(*, unavailable, message: "Not supported yet")
    open override var adjustsFontSizeToFitWidth: Bool {
        get { return false }
        set { }
    }

    open override var delegate: UITextFieldDelegate? {
        get { return proxyDelegate }
        set { proxyDelegate = newValue }
    }
    internal weak var proxyDelegate: UITextFieldDelegate? = nil

    open override var borderStyle: UITextField.BorderStyle {
        get { return styleType }
        set { styleType = newValue }
    }
    var styleType: UITextField.BorderStyle = .roundedRect {
        didSet { updateStyleType() }
    }

    // MARK: - Inner structure

    let mainContainer: UIStackView = {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .vertical
        container.alignment = .fill
        container.spacing = 4
        container.isUserInteractionEnabled = true
        return container
    }()
    let fieldContainer: UIStackView = {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .horizontal
        container.alignment = .fill
        container.spacing = 8
        container.isUserInteractionEnabled = true
        return container
    }()

    var mainContainerTop: NSLayoutConstraint!
    var mainContainerLeft: NSLayoutConstraint!
    var mainContainerRight: NSLayoutConstraint!
    var mainContainerBottom: NSLayoutConstraint!

    let field: UnderlyingField = UnderlyingField()

    // MARK: - Right Accessory

    open override var rightView: UIView?  {
        get { return rightInputAccessory }
        set { rightAccessory = newValue != nil ? .view(newValue!) : .none }
    }
    @available(*, unavailable, message: "Only for IB. Use `set(rightIcon:for:)` instead")
    @IBInspectable public var rightIcon: UIImage? { willSet { rightIconFromIB = newValue } }
    var rightIconFromIB: UIImage?

    public var rightAccessory: Accessory = .none { didSet { buildRightAccessory() } }
    let rightAccessoryView = UIView()
    var rightInputAccessory: UIView?

    // MARK: - Left Accessory

    open override var leftView: UIView? {
        get { return leftInputAccessory }
        set { leftAccessory = newValue != nil ? .view(newValue!) : .none }
    }
    @available(*, unavailable, message: "Only for IB. Use `set(leftIcon:for:)` instead")
    @IBInspectable public var leftIcon: UIImage? { willSet { leftIconFromIB = newValue } }
    var leftIconFromIB: UIImage?

    public var leftAccessory: Accessory = .none { didSet { buildLeftAccessory() } }
    let leftAccessoryView = UIView()
    var leftInputAccessory: UIView? { didSet { oldValue?.clear(); update() } }

    // MARK: - Placeholder label

    public var placeholderLabel: UILabel { return floatingLabel }
    let floatingLabel = UILabel()

    var topPadding: CGFloat {
        return floatingLabel.font.lineHeight * placeholderScaleMultiplier
    }
    var bottomPadding: CGFloat {
        return infoLabel.bounds.height + lineContainer.bounds.height + mainContainer.spacing * 2
    }

    // MARK: - Underline container

    var lineContainer = UIView()
    var lineViewHeight: NSLayoutConstraint?
    var line = UnderlyingLineView()

    // MARK: - Background View

    let backgroundView = BackgroundView()

    // MARK: - Bezel layer

    let bezelView = BezelView()

    // MARK: - Info view

    public let infoLabel = InfoLabel()
    let infoContainer: UIStackView = {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .horizontal
        container.alignment = .fill
        container.spacing = 4
        container.isUserInteractionEnabled = true
        return container
    }()
    let infoAccessory = InfoLabel()

    // MARK: - Properties

    var observations: [Any] = []
    var isBuilt: Bool = false
    var overrideAnimated: Bool?

    public var placeholderAdjustment: CGFloat = 0.9

    var placeholderScaleMultiplier: CGFloat { return placeholderPointSize / fontSize * placeholderAdjustment }
    var fontSize: CGFloat { return font?.pointSize ?? 17 }

    // MARK: - Lifecycle

    lazy var buildOnce: () -> Void = {
        setup()
        build()
        setupPostBuild()
        setupObservers()
        buildFloatingLabel()
        return {}
    }()

    open override func layoutSubviews() {
        buildOnce(); super.layoutSubviews(); updateFieldState()
    }

    // MARK: - Area

    var rectLeftPadding: CGFloat {
        guard let width = leftInputAccessory?.bounds.width else { return 0 }
        guard !leftAccessoryView.isHidden else { return 0 }
        return width + fieldContainer.spacing
    }

    var rectRightPadding: CGFloat {
        guard let width = rightInputAccessory?.bounds.width else { return 0 }
        guard !rightAccessoryView.isHidden else { return 0 }
        return width + fieldContainer.spacing
    }

    private var textInsets: UIEdgeInsets {
        return UIEdgeInsets(
            top: topPadding + insets.top,
            left: rectLeftPadding + insets.left,
            bottom: bottomPadding + insets.bottom,
            right: rectRightPadding + insets.right
        )
    }

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        let base = super.textRect(forBounds: bounds)
        return base.inset(by: textInsets)
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let base = super.editingRect(forBounds: bounds)
        return base.inset(by: textInsets)
    }

    open override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var base = super.clearButtonRect(forBounds: bounds)
        base = base.offsetBy(dx: -rectRightPadding - insets.right, dy: -base.minY - base.height / 2)
        base = base.offsetBy(dx: 0, dy: backgroundView.bounds.height / 2 + 2)
        return base
    }

    open override func caretRect(for position: UITextPosition) -> CGRect {
        return super.caretRect(for: position).insetBy(dx: 0, dy: fontSize * 0.12)
    }

    // MARK: - Setup

    func setup() {
        placeholder = super.placeholder ?? self.placeholder
        super.placeholder = nil
        super.borderStyle = .none
        super.adjustsFontSizeToFitWidth = false
        field.adjustsFontSizeToFitWidth = false

        super.rightView = nil
        super.leftView = nil
        rightAccessoryView.backgroundColor = .clear
        leftAccessoryView.backgroundColor = .clear

        // Setup default style
        updateStyleType()

        superBackgroundColor = super.backgroundColor
        super.backgroundColor = .clear

        if let defaultStyle = self.defaultStyle {
            setIfPossible(&defaultStyle.defaultColor, to: textColor)
            setIfPossible(&defaultStyle.defaultPlaceholderColor, to: textColor)
            setIfPossible(&defaultStyle.backgroundColor, to: superBackgroundColor)
            setIfPossible(&defaultStyle.focusedColor, to: tintColor)
        }

        placeholderLabel.font = font ?? placeholderLabel.font

        field.font = font
        field.textColor = .clear
        field.text = placeholder ?? "-"
        field.backgroundColor = .clear
        field.isUserInteractionEnabled = false

        infoLabel.font = (font ?? infoLabel.font)?.withSize(11)
        infoLabel.lineBreakMode = .byTruncatingTail
        infoLabel.numberOfLines = 1
    }

    func setupPostBuild() {
        if let rightIcon = rightIconFromIB {
            rightAccessory = .action(rightIcon)
        }
        if let leftIcon = leftIconFromIB {
            leftAccessory = .info(leftIcon)
        }
        insets = defaultStyle?.insets ?? insets
    }

    func setupObservers() {
        observations = [
            observe(\.fieldState) { it, _ in it.update(animated: true) },
            observe(\.text) { it, _ in it.updateCharactersCount() },
            observe(\.text) { it, _ in it.updateFieldState() },
        ]
        addTarget(self, action: #selector(updateText), for: .editingChanged)
        addTarget(self, action: #selector(preventImplicitAnimations), for: .editingDidEnd)
    }
}

// MARK: - Update

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

// MARK: - Build UI Phase

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
        line.underAccessory = extendLineUnderAccessory
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
