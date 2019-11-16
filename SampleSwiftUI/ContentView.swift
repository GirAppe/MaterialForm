//
//  ContentView.swift
//  SampleSwiftUI
//
//  Created by Andrzej Michnia on 15/10/2019.
//  Copyright © 2019 MakeAWishFoundation. All rights reserved.
//

import SwiftUI
import MaterialFormSwiftUI

struct ContentView: View {

    @State var events: [String] = []
    @State var fieldValue: String = ""
    @State var infoValue: String = ""
    @State var errorValue: String? = nil

    @State var selectedStyle: Int = 3
    let styleNames: [String] = ["None", "Line", "Bezel", "RoundedRect"]
    let styles: [UITextField.BorderStyle] = [.none, .line, .bezel, .roundedRect]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("MaterialTextField")) {
                    MaterialTextField(
                        title: "Default placeholder",
                        text: $fieldValue,
                        info: $infoValue,
                        error: $errorValue,
                        borderStyle: styles[selectedStyle]
                    ) {
                        $0.clearButtonMode = .whileEditing
                    }
                }
                Section(header: Text("Field configuration")) {
                    Picker(selection: $selectedStyle, label: Text("Border style:")) {
                        ForEach(0..<styleNames.count) { idx in
                            Text("\(self.styleNames[idx])").tag(idx)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    MaterialTextField(title: "Info value", text: $infoValue) {
                        $0.clearButtonMode = .whileEditing
                    }
                }
            }
            .navigationBarTitle(Text("MaterialForm"))
            .accentColor(.green)
        }
        .onAppear { UITableView.appearance().separatorStyle = .none }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView().environment(\.colorScheme, .dark)
        }
    }
}
#endif
