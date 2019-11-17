//
//  ContentView.swift
//  SampleSwiftUI
//
//  Created by Andrzej Michnia on 15/10/2019.
//  Copyright © 2019 MakeAWishFoundation. All rights reserved.
//

import SwiftUI
import MaterialForm

struct ContentView: View {

    // MARK: - State

    @State var events: [FieldEventEntry] = []
    @State var fieldValue: String = ""
    @State var infoValue: String = ""
    @State var errorValue: String? = nil
    @State var characterCount: String = "0"
    @State var selectedStyle: Int = 3

    @State var showsError: Bool = false
    @State var editing: Bool = true
    @State var showCharacterCount: Bool = true
    @State var underAccessory: Bool = true

    @State var leftAccessory: Int = 0
    @State var rightAccessory: Int = 0

    // MARK: - Properties

    let styleNames: [String] = ["None", "Line", "Bezel", "RoundedRect"]
    let styles: [UITextField.BorderStyle] = [.none, .line, .bezel, .roundedRect]
    let accessory: [MaterialTextField.Accessory] = [
        .none,
        .info(#imageLiteral(resourceName: "show").withRenderingMode(.alwaysTemplate)),
        .action(#imageLiteral(resourceName: "show").withRenderingMode(.alwaysTemplate)),
        .error(#imageLiteral(resourceName: "show").withRenderingMode(.alwaysTemplate))
    ]
    let accessoryName = ["None", "Info", "Action", "Error"]

    // MARK: - UI

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("MaterialTextField")) {
                    MaterialTextField(
                        title: "Default placeholder",
                        text: $fieldValue,
                        info: $infoValue,
                        error: .constant(showsError ? "Default error message" : nil),
                        action: { event in
                            self.events.append(FieldEventEntry(self.events.count, event))
                        },
                        style: {
                            $0.borderStyle = self.styles[self.selectedStyle]
                            $0.clearButtonMode = .whileEditing
                            $0.showCharactersCounter = self.showCharacterCount
                            $0.maxCharactersCount = Int(self.characterCount) ?? 0
                            $0.isEditingEnabled = self.editing
                            $0.extendLineUnderAccessory = self.underAccessory
                            $0.leftAccessory = self.accessory[self.leftAccessory]
                            $0.rightAccessory = self.accessory[self.rightAccessory]
                        }
                    )
                }
                Section(header: Text("Field configuration")) {
                    Text("Border style:")
                    Picker(selection: $selectedStyle, label: Text("Border style:")) {
                        ForEach(0..<styleNames.count) { idx in
                            Text("\(self.styleNames[idx])").tag(idx)
                        }
                    }
                    VStack {
                        Toggle("Show error", isOn: $showsError)
                        Toggle("Editing", isOn: $editing)
                        Toggle("Character count", isOn: $showCharacterCount)
                        Toggle("Line under accessory", isOn: $underAccessory)
                    }
                    MaterialTextField(title: "Info value", text: $infoValue) {
                        $0.clearButtonMode = .whileEditing
                    }
                    MaterialTextField(
                        title: "Max characters count",
                        text: $characterCount,
                        info: .constant("0 means no limit")
                    ) {
                        $0.clearButtonMode = .whileEditing
                        $0.keyboardType = .numberPad
                    }
                    Button("Set text from code") { self.fieldValue = "Default text set from code" }
                    Button("Clear from code") { self.fieldValue = "" }
                    Group {
                        Text("Left accessory")
                        Picker(selection: $leftAccessory, label: Text("")) {
                            ForEach(0..<accessory.count) { idx in
                                Text("\(self.accessoryName[idx])").tag(idx)
                            }
                        }
                        Text("Right accessory")
                        Picker(selection: $rightAccessory, label: Text("")) {
                            ForEach(0..<accessory.count) { idx in
                                Text("\(self.accessoryName[idx])").tag(idx)
                            }
                        }
                    }
                }
                Section(header: Text("Events")) {
                    ForEach(events.reversed()) { Text("\($0.id)]  " + $0.name) }
                }
            }
            .navigationBarTitle(Text("MaterialForm"))
            .accentColor(.green)
            .pickerStyle(SegmentedPickerStyle())
        }
        .onAppear { UITableView.appearance().separatorStyle = .none }
    }
}

struct FieldEventEntry: Identifiable {
    let id: Int
    let name: String

    init(_ id: Int, _ event: MaterialTextField.Event) {
        self.id = id

        switch event {
        case .beginEditing: name = "begin editing"
        case .endEditing: name = "end editing"
        case .clear: name = "clear"
        case .tap: name = "tap on control"
        case .leftAccessoryTap: name = "left accessory action"
        case .rightAccessoryTap: name = "right accessory action"
        case .returnTap: name = "return"
        case .none: name = "none"
        }
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
