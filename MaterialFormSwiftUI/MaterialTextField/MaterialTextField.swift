import SwiftUI
import MaterialForm

// MARK: - Material Text Field

public struct MaterialTextField: UIViewRepresentable {

    public typealias UIField = MaterialForm.MaterialUITextField
    public typealias Styling = (UIField) -> Void
    public typealias Event = MaterialForm.FieldTriggerEvent
    public typealias EventHandler = (Event) -> Void

    // MARK: - Properties

    @Binding public var title: String
    @Binding public var text: String
    @Binding public var info: String
    @Binding public var error: String?
    @Binding public var maxCharacterCount: Int

    public var borderStyle: UITextField.BorderStyle

    var isShowingError: Bool { error != nil }

    // MARK: - Internal properties

    private let uiField = UIField()
    private let style: Styling?

    // MARK: - Initializers

    public init(
        title: Binding<String>,
        text: Binding<String>,
        info: Binding<String>? = nil,
        error: Binding<String?>? = nil,
        maxCharacterCount: Binding<Int>? = nil,
        borderStyle: UITextField.BorderStyle = .roundedRect,
        action: EventHandler? = nil,
        style: Styling? = nil
    ) {
        self._title = title
        self._text = text
        self._info = info ?? .constant("")
        self._error = error ?? .constant(nil)
        self._maxCharacterCount = maxCharacterCount ?? .constant(0)
        self.borderStyle = borderStyle
        self.style = style
    }

    public init(
        title: String,
        text: Binding<String>,
        info: Binding<String>? = nil,
        error: Binding<String?>? = nil,
        maxCharacterCount: Binding<Int>? = nil,
        borderStyle: UITextField.BorderStyle = .roundedRect,
        action: EventHandler? = nil,
        style: Styling? = nil
    ) {
        self.init(
            title: .constant(title),
            text: text,
            info: info,
            error: error,
            maxCharacterCount: maxCharacterCount,
            borderStyle: borderStyle,
            action: action,
            style: style
        )
    }
}

// MARK: - UIViewRepresentable

public extension MaterialTextField {

    func makeUIView(context: Context) -> UIField {
        uiField.text = text
        uiField.borderStyle = .roundedRect
        uiField.placeholder = title
        uiField.borderStyle = borderStyle

        uiField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        uiField.setContentCompressionResistancePriority(.required, for: .vertical)
        uiField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        style?(uiField)
        uiField.setNeedsLayout()
        uiField.setNeedsDisplay()

        return uiField
    }

    func updateUIView(_ uiField: UIField, context: Context) {
        uiField.placeholder = title
        uiField.text = text
        uiField.errorMessage = error
        uiField.infoMessage = info
        uiField.maxCharactersCount = maxCharacterCount
        uiField.borderStyle = borderStyle
        style?(uiField)
        uiField.setNeedsLayout()
        uiField.setNeedsDisplay()
    }
}

// MARK: - Coordinator

public extension MaterialTextField {

    func makeCoordinator() -> Coordinator {
        Coordinator(of: self)
    }

    class Coordinator: NSObject {
        var textObservation: Any

        init(of field: MaterialTextField) {
            textObservation = field.uiField.observe(\MaterialUITextField.text) { it, _ in
                DispatchQueue.main.async { field.text = it.text ?? "" }
            }
        }
    }
}

// MARK: - Styling

public extension MaterialTextField {

    func style(_ style: (MaterialUITextField) -> Void) -> some View {
        style(uiField)
        return self
    }
}
