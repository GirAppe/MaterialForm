#if os(iOS) || os(tvOS)

import UIKit

internal let isDebuggingViewHierarchy = false

// MARK: - Main Implementation

@available(iOS 10, *)
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
        var maxHeight = super.textRect(forBounds: bounds).height
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
    open override var font: UIFont? { willSet { field.font = newValue; floatingLabel.font = newValue } }
    open override var tintColor: UIColor! { didSet { update() } }
    open override var backgroundColor: UIColor? {
        get { return backgroundView.backgroundColor }
        set { backgroundView.backgroundColor = newValue }
    }
    internal var superBackgroundColor: UIColor?

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

    // MARK: - Area

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
    @available(*, unavailable, message: "Only for IB. Use `rightAccessory` instead")
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
    @available(*, unavailable, message: "Only for IB. Use `leftAccessory` instead")
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
    var lineHeight: CGFloat { return lineContainer.bounds.height }

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
        buildLeftAccessory()
        buildRightAccessory()
        return {}
    }()

    open override func layoutSubviews() {
        buildOnce()
        super.layoutSubviews()
        updateFieldState()
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
#endif
