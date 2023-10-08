#if canImport(UIKit)

import UIKit

internal let isDebuggingViewHierarchy = false

// MARK: - Main Implementation

@available(iOS 10, *)
open class MaterialUITextField: UITextField, MaterialFieldState {

    // MARK: - Configuration

    /// Specify next responder text field, that would be activated when return button pressed
    @IBOutlet open weak var nextField: UITextField?

    /// Makes intrinsic content size being at least X in height.
    /// Defaults to 64 (recommended 44 + some buffer for the placeholder).
    /// And it is a nice number because of being power of 2.
    @IBInspectable open var minimumHeight: CGFloat = 64 { didSet { update() } }
    /// Point size of the placeholder label when field is filled/active
    @IBInspectable open var placeholderPointSize: CGFloat = 11 { didSet { update() } }
    /// Point size of the info text (also error text and characters counter)
    @IBInspectable open var infoPointSize: CGFloat = 11 { didSet { update() } }
    /// Set to true if the line should be extended under right accessory view
    @IBInspectable open var extendLineUnderAccessory: Bool = true { didSet { update() } }

    /// Used when border style is `.rounded` or `.bezel`
    @IBInspectable open var radius: CGFloat {
        get { style.cornerRadius }
        set { style.cornerRadius = newValue; updateCornerRadius() }
    }
    /// Content insets. Used for text, placeholder and accessories positioning
    open var insets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 0, right: 12) {
        didSet { update(animated: false) }
    }

    /// Additional correction for main text area
    open var textInsetsCorrection: UIEdgeInsets = {
        #if os(tvOS)
        return UIEdgeInsets(top: 0, left: -6, bottom: 0, right: -6)
        #else
        return .zero
        #endif
    }()

    /// Horizontal spacing between content text fields and accessories
    open var innerHorizontalSpacing: CGFloat {
        get { fieldContainer.spacing }
        set { fieldContainer.spacing = newValue; update(animated: false) }
    }
    /// Vertical spacing between text, line and info label
    open var innerVerticalSpacing: CGFloat {
        get { mainContainer.spacing }
        set { mainContainer.spacing = newValue; update(animated: false) }
    }

    /// If value is greater than `0`, it would constrain content text size, disabling appending new characters
    @IBInspectable open var maxCharactersCount: Int = 0 { didSet { update() } }
    /// If `false`, the text field is not editable by the user. Accessories can still be tapped.
    @IBInspectable open var isEditingEnabled: Bool = true  { didSet { update() } }
    /// If `true`, shows characters counter on the bottom right
    @IBInspectable open var showCharactersCounter: Bool = false { didSet { update() } }

    // MARK: - Animation Configuration

    /// Field state transition animation curve. For use with IB only. Use
    ///
    /// Valid vales are:
    /// - easeInOut
    /// - easeIn
    /// - easeOut
    /// - linear
    @IBInspectable open var animationCurve: String? {
        willSet { curve = AnimationCurve(name: newValue) ?? curve }
    }
    /// Field state transition animation duration. Defaults to 0.36b.
    open var animationDuration: Float = 0.36
    /// Field state transition animation damping. Defaults to 1.
    open var animationDamping: Float = 1
    /// Field state transition animation curve.
    open var curve: AnimationCurve = .easeInOut

    var duration: TimeInterval { TimeInterval(animationDuration) }
    var damping: CGFloat { CGFloat(animationDamping) }

    // MARK: - Context Actions

    open var allowedContextActions: [MaterialFieldContextAction] = MaterialFieldContextAction.allCases

    // MARK: - Error handling

    /// Returns `true` when field is showing `errorMessage` (it is not `nil`). Readonly.
    public var isShowingError: Bool { return infoLabel.errorValue != nil }

    /// If set to value, field would go into error state, showing `errorMessage` instead of `infoMessage`. Set to `nil` to turn off showing error.
    public var errorMessage: String? { didSet { update() } }
    /// Info / description message below field. It is constraind to single line for now!
    @IBInspectable public var infoMessage: String? { didSet { update() } }

    // MARK: - Style

    /// Use it to set a custom style of the `MaterialUITextField`.
    public var style: MaterialTextFieldStyle = DefaultMaterialTextFieldStyle() {
        didSet { insets = defaultStyle?.insets ?? insets; update(animated: false) }
    }
    var defaultStyle: DefaultMaterialTextFieldStyle? { style as? DefaultMaterialTextFieldStyle }

    // MARK: - Observable properties

    /// [Observable it with KVO] Event trigerred (like accessory tap).
    @objc dynamic internal(set) public var event: FieldTriggerEvent = .none

    /// [Observable it with KVO] Field state (empty/focused/filled).
    @objc dynamic private(set) public var fieldState: FieldControlState = .empty

    internal func setFieldState(_ newState: FieldControlState, animated: Bool) {
        self.fieldState = newState
        self.update(animated: animated)
    }

    // MARK: - Overrides

    /// [Internal] Overrides intrinsic content size to take into account insets and height constraints (minimum height).
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
    /// The string that is displayed when there is no other text in the text field. It would slide to top left and scale down when field is focused ot filled
    open override var placeholder: String? {
        get { floatingLabel.text }
        set { floatingLabel.text = newValue; update(animated: false) }
    }
    /// Font used in all labels throughout text field. Applies to the entire text of the text field. It also applies to the placeholder text, error text,
    /// info text and characters counter. Please note, that info/error.placeholder texts would be scaled to appropriate point sizes.
    open override var font: UIFont? { willSet { field.font = newValue; floatingLabel.font = newValue } }
    /// The first nondefault tint color value in the view’s hierarchy, ascending from and starting with the view itself.
    open override var tintColor: UIColor! { didSet { update() } }
    /// The view’s background color.
    open override var backgroundColor: UIColor? {
        get { backgroundView.backgroundColor }
        set { backgroundView.backgroundColor = newValue; superBackgroundColor = newValue }
    }
    internal var superBackgroundColor: UIColor?
    @available(*, unavailable, message: "Not supported yet")
    open override var background: UIImage? {
        get { nil }
        set { }
    }

    @available(*, unavailable, message: "Not supported yet")
    open override var adjustsFontSizeToFitWidth: Bool {
        get { false }
        set { }
    }

    /// The receiver’s delegate. **Suggested to use KVO observable properties, such as:** `event`, `fieldState` **and** `text` **instead!**
    ///
    /// A text field delegate responds to editing-related messages from the text field. You can use the delegate to respond to the text entered
    /// by the user and to some special commands, such as when Return is tapped.
    open override var delegate: UITextFieldDelegate? {
        get { proxyDelegate }
        set { proxyDelegate = newValue }
    }
    internal weak var proxyDelegate: UITextFieldDelegate? = nil

    /// The border style used by the text field.
    ///
    /// Available valuess:
    /// - `none` - would show underline only if field is active. No borders.
    /// - `line` - Always show bottom underline.
    /// - `bezel` - show with rounded border, no underline
    /// - `roundedRect` - Default material text field style, with gray background, underline and two top corners rounded
    open override var borderStyle: UITextField.BorderStyle {
        get { styleType }
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
        super.caretRect(for: position).insetBy(dx: 0, dy: fontSize * 0.12)
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

    /// Could be used to specify right accessory view. **Preferred to use** `rightAccessory` **instead!**
    open override var rightView: UIView?  {
        get { rightInputAccessory }
        set { rightAccessory = newValue != nil ? .view(newValue!) : .none }
    }
    @IBInspectable public var rightIcon: UIImage? { willSet { rightIconFromIB = newValue } }
    var rightIconFromIB: UIImage?

    /// Used to setup right accessory. Please refer to `MaterialUITextField.Accessory` for overview of possible options.
    public var rightAccessory: Accessory = .none { didSet { buildRightAccessory() } }
    let rightAccessoryView = UIView()
    var rightInputAccessory: UIView?

    // MARK: - Left Accessory

    /// Could be used to specify left accessory view. **Preferred to use** `leftAccessory` **instead!**
    open override var leftView: UIView? {
        get { return leftInputAccessory }
        set { leftAccessory = newValue != nil ? .view(newValue!) : .none }
    }
    @IBInspectable public var leftIcon: UIImage? { willSet { leftIconFromIB = newValue } }
    var leftIconFromIB: UIImage?

    /// Used to setup left accessory. Please refer to `MaterialUITextField.Accessory` for overview of possible options.
    public var leftAccessory: Accessory = .none { didSet { buildLeftAccessory() } }
    let leftAccessoryView = UIView()
    var leftInputAccessory: UIView? { didSet { oldValue?.clear(); update() } }

    // MARK: - Placeholder label

    /// [Internal] placeholder label. Altering properties might render unexpected behaviours.
    public var placeholderLabel: UILabel { return floatingLabel }
    let floatingLabel = UILabel()

    var topPadding: CGFloat { floatingLabel.font.lineHeight * placeholderScaleMultiplier }
    var bottomPadding: CGFloat { infoLabel.bounds.height + lineContainer.bounds.height + mainContainer.spacing * 2 }

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

    /// [Internal] info label. Altering properties might render unexpected behaviours.
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

    /// Additional correction to placeholder adjustment when field is filled/active. Default is 0.9. Intended to be used with non standard text size or font
    public var placeholderAdjustment: CGFloat = 0.9

    var placeholderScaleMultiplier: CGFloat { return placeholderPointSize / fontSize * placeholderAdjustment }
    var fontSize: CGFloat { return font?.pointSize ?? 17 }

    // MARK: - Lifecycle

    private lazy var buildOnce: () -> Void = {
        build()
        setupPostBuild()
        setupObservers()
        buildFloatingLabel()
        buildLeftAccessory()
        buildRightAccessory()
        return {}
    }()
    private func setupBuilding() { isInViewHierarchy ? buildOnce() : () }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    open override func layoutSubviews() {
        setupBuilding()
        super.layoutSubviews()
        updateFieldState()
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        setupBuilding()
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupBuilding()
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


        superBackgroundColor = backgroundColor ?? super.backgroundColor
        super.backgroundColor = .clear

        // Setup default style
        updateStyleType()

        placeholderLabel.font = font ?? placeholderLabel.font

        field.font = font
        field.textColor = .clear
        field.text = placeholder ?? "-"
        field.backgroundColor = .clear
        field.isUserInteractionEnabled = false

        infoLabel.font = (font ?? infoLabel.font)?.withSize(infoPointSize)
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
            observe(\.text) { it, _ in it.updateCharactersCount() },
            observe(\.text) { it, _ in it.updateFieldState() },
        ]
        addTarget(self, action: #selector(updateText), for: .editingChanged)
        addTarget(self, action: #selector(preventImplicitAnimations), for: .editingDidEnd)
    }
}
#endif
