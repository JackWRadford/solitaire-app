//
//  EnumPicker.swift
//  Solitaire
//
//  Created by Jack Radford on 02/10/2023.
//

import SwiftUI

/// Displays all cases for the enum of type `T` inside a Picker.
/// The Picker selection uses the `selection` binding
/// The Picker label uses `label`
struct EnumPicker<T: CaseIterable & Identifiable & RawRepresentable & Hashable> : View where T.AllCases: RandomAccessCollection, T.RawValue: Hashable & StringProtocol {
    
    var label: String
    @Binding var selection: T
    
    var body: some View {
        Picker(label, selection: $selection) {
            ForEach(T.allCases) { enumCase in
                Text(LocalizedStringKey(enumCase.rawValue as! String))
                    .tag(enumCase.rawValue)
            }
        }
    }
}

struct EnumPicker_Previews: PreviewProvider {
    static var previews: some View {
        EnumPicker<Theme>(label:"Theme", selection: .constant(Theme.system))
    }
}

