import SwiftUI
import MaterialForm

// MARK: - Material Text Field

public struct MaterialTextField: UIViewRepresentable {

    public typealias UIField = MaterialUITextField
    public typealias Styling = (MaterialUITextField) -> Void

    // MARK: - Properties

    @Binding public var title: String
    @Binding public var text: String
    @Binding public var info: String?
    @Binding public var error: String?

    var isShowingError: Bool { error != nil }

    // MARK: - Internal properties

    private let uiField = UIField()
    private let style: Styling?

    // MARK: - Initializers

    public init(
        title: Binding<String>,
        text: Binding<String>,
        info: Binding<String?>? = nil,
        error: Binding<String?>? = nil,
        styling: Styling? = nil
    ) {
        self._title = title
        self._text = text
        self._info = info ?? .constant(nil)
        self._error = error ?? .constant(nil)
        self.style = styling
    }

    public init(
        title: String,
        text: Binding<String>,
        info: Binding<String?>? = nil,
        error: Binding<String?>? = nil,
        styling: Styling? = nil
    ) {
        self.init(
            title: .constant(title),
            text: text,
            info: info,
            error: error,
            styling: styling
        )
    }
}

// MARK: - UIViewRepresentable

public extension MaterialTextField {

    func makeUIView(context: Context) -> UIField {
        uiField.text = text
        uiField.borderStyle = .roundedRect
        uiField.placeholder = title

        uiField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        uiField.setContentCompressionResistancePriority(.required, for: .vertical)
        uiField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        style?(uiField)

        return uiField
    }

    func updateUIView(_ field: UIField, context: Context) {
        field.placeholder = title
        field.text = text
        style?(uiField)
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

// MARK: - Not yet available

//struct MaterialTextFieldStyle: TextFieldStyle {
//    typealias Body = MaterialTextField
//
//    @State var aaa = ""
//
//    func _body(configuration: TextField<Self._Label>) -> MaterialTextFieldStyle.Body {
//        return MaterialTextField(title: "aaa", text: $aaa)
//    }
//
//    typealias Configuration = Void
//}
