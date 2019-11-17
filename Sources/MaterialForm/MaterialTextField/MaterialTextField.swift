#if canImport(UIKit) && canImport(SwiftUI)
import SwiftUI
import UIKit

// MARK: - Material Text Field

@available(iOS 13, *)
public struct MaterialTextField: UIViewRepresentable {

    public typealias UIField = MaterialForm.MaterialUITextField
    public typealias Styling = (UIField) -> Void
    public typealias Event = MaterialForm.FieldTriggerEvent
    public typealias EventHandler = (Event) -> Void
    public typealias Accessory = MaterialUITextField.Accessory

    // MARK: - Properties

    @Binding public var title: String
    @Binding public var text: String
    @Binding public var info: String
    @Binding public var error: String?
    @Binding public var maxCharacterCount: Int

    var isShowingError: Bool { error != nil }
    let action: EventHandler?

    // MARK: - Internal properties

    private let uiField = UIField()
    private let style: Styling

    // MARK: - Initializers

    public init(
        title: Binding<String>,
        text: Binding<String>,
        info: Binding<String>? = nil,
        error: Binding<String?>? = nil,
        maxCharacterCount: Binding<Int>? = nil,
        action: EventHandler? = nil,
        style: @escaping Styling = { _ in }
    ) {
        self._title = title
        self._text = text
        self._info = info ?? .constant("")
        self._error = error ?? .constant(nil)
        self._maxCharacterCount = maxCharacterCount ?? .constant(0)
        self.style = style
        self.action = action
    }

    public init(
        title: String,
        text: Binding<String>,
        info: Binding<String>? = nil,
        error: Binding<String?>? = nil,
        maxCharacterCount: Binding<Int>? = nil,
        action: EventHandler? = nil,
        style: @escaping Styling = { _ in }
    ) {
        self.init(
            title: .constant(title),
            text: text,
            info: info,
            error: error,
            maxCharacterCount: maxCharacterCount,
            action: action,
            style: style
        )
    }
}

// MARK: - UIViewRepresentable

@available(iOS 13, *)
public extension MaterialTextField {

    func makeUIView(context: Context) -> UIField {
        uiField.text = text
        uiField.borderStyle = .roundedRect
        uiField.placeholder = title

        uiField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        uiField.setContentCompressionResistancePriority(.required, for: .vertical)
        uiField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        style(uiField)
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
        style(uiField)
        uiField.setNeedsLayout()
        uiField.setNeedsDisplay()
    }
}

// MARK: - Coordinator

@available(iOS 13, *)
public extension MaterialTextField {

    func makeCoordinator() -> Coordinator {
        Coordinator(of: self)
    }

    class Coordinator: NSObject {
        var textObservation: Any
        var eventObservation: Any

        init(of field: MaterialTextField) {
            textObservation = field.uiField.observe(\.text) { it, _ in
                DispatchQueue.main.async { field.text = it.text ?? "" }
            }
            eventObservation = field.uiField.observe(\.event) { it, _ in
                DispatchQueue.main.async { field.action?(it.event) }
            }
        }
    }
}

// MARK: - Styling

@available(iOS 13, *)
public extension MaterialTextField {

    func style(_ style: (MaterialUITextField) -> Void) -> some View {
        style(uiField)
        return self
    }
}

#endif
