import SwiftUI
import MaterialForm

// MARK: - Material Text Field

public struct MaterialTextField: UIViewRepresentable {

    public typealias UIField = MaterialUITextField

    // MARK: - Properties

    @Binding public var title: String
    @Binding public var text: String

    // MARK: - Internal properties

    private let uiField = UIField()

    // MARK: - Initializers

    public init(title: Binding<String>, text: Binding<String>) {
        self._title = title
        self._text = text
    }

    public init(title: String, text: Binding<String>) {
        self._title = .constant(title)
        self._text = text
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

        return uiField
    }

    func updateUIView(_ field: UIField, context: Context) {
        field.placeholder = title
        field.text = text
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
