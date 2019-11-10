//
//  ContentView.swift
//  SampleSwiftUI
//
//  Created by Andrzej Michnia on 15/10/2019.
//  Copyright © 2019 MakeAWishFoundation. All rights reserved.
//

import SwiftUI
import MaterialForm

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

// MARK: - Material Text Field

struct MaterialTextField: UIViewRepresentable {

    typealias Field = MaterialUITextField

    // MARK: - Properties

    var title: String
    @Binding var text: String

    private let uiField = Field()

    func makeUIView(context: Context) -> Field {
        uiField.placeholder = title
        uiField.text = text
        uiField.borderStyle = .roundedRect

        uiField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiField.setContentHuggingPriority(.defaultLow, for: .horizontal)

        return uiField
    }

    func updateUIView(_ field: Field, context: Context) {
        field.placeholder = title
        field.text = text
    }
}

// MARK: - Coordinator

extension MaterialTextField {

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

struct ContentView: View {

    @State var string: String = ""

    var body: some View {
        VStack {
            Text("Hello World")
            MaterialTextField(title: "Test 1", text: $string)
                .padding(8)
//            MaterialTextField(title: "Test2", text: $string)
            TextField("Test 2", text: $string)
//                .textFieldStyle(MaterialTextFieldStyle())
                .padding(8)
            TextField("Test 3", text: $string)
                .padding(8)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
