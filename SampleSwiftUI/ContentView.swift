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
            Text("Hello World")
            MaterialTextField(title: "Test 1", text: $string)
                .padding(8)
            MaterialTextField(title: $placeholder, text: $string)
                .padding(8)
            MaterialTextField(title: "Placeholder above:", text: $placeholder)
                .padding(8)
            TextField("Test 3", text: $string)
                .padding(8)
            TextField("Test 4", text: $string)
                .padding(8)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
