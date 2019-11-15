//
//  ContentView.swift
//  SampleSwiftUI
//
//  Created by Andrzej Michnia on 15/10/2019.
//  Copyright © 2019 MakeAWishFoundation. All rights reserved.
//

import SwiftUI
import MaterialForm
import MaterialFormSwiftUI

struct ContentView: View {

    @State var string: String = ""
    @State var placeholder: String = "placeholder asdasd asdasd"

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("test")) {
                    MaterialTextField(title: "Test 1", text: $string) {
                        $0.borderStyle = .bezel
                        $0.textColor = .brown
                        $0.font = .systemFont(ofSize: 16, weight: .semibold)
                    }
                    MaterialTextField(title: $placeholder, text: $string) {
                        $0.textColor = .darkText
                        $0.clearButtonMode = .whileEditing
                        $0.borderStyle = .line
                        $0.leftAccessory = .info(#imageLiteral(resourceName: "show").withRenderingMode(.alwaysTemplate))
                    }
                    MaterialTextField(title: "Long text for placeholder above:", text: $placeholder) {
                        $0.textColor = .blue
                        $0.clearButtonMode = .always
                        $0.font = .systemFont(ofSize: 32, weight: .semibold)
                    }
                }
                Spacer()
                TextField("Test 2", text: $string)
            }
            .navigationBarTitle(Text("MaterialForm"))
            .accentColor(.orange)
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
