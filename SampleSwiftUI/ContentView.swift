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
    @State var placeholder: String = "placeholder"

    var body: some View {
        VStack {
            MaterialTextField(title: "Test 1", text: $string)
                .padding(8)
                .textContentType(UITextContentType.password)
            MaterialTextField(title: $placeholder, text: $string)
                .padding(8)
            MaterialTextField(title: "Placeholder above:", text: $placeholder)
                .styled { field in
                    field.font = UIFont.systemFont(ofSize: 40, weight: .bold)
                    field.textColor = .blue
                    field.showCharactersCounter = true
                    field.clearButtonMode = .whileEditing
                    field.leftAccessory = .info(#imageLiteral(resourceName: "show"))
                }
                .padding(8)
            TextField("Test 4", text: $string)
                .padding(8)
                .foregroundColor(.green)
        }
        .padding(.bottom, 320)
        .accentColor(.orange)
        .foregroundColor(.green)
        .font(.system(size: 20, weight: .bold, design: .default))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
