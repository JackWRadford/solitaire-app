//
//  SettingsView.swift
//  Solitaire
//
//  Created by Jack Radford on 02/10/2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(UDKey.theme()) private var theme = Theme.system
    
    var body: some View {
        NavigationStack {
            Form {
                EnumPicker(label: "Theme", selection: $theme)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    dismissButton
                }
            }
        }
        .preferredColorScheme(theme.toColorScheme())
    }
    
    private var dismissButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
