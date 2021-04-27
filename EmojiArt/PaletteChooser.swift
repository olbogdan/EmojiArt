//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by bogdanov on 25.04.21.
//

import SwiftUI

struct PaletteChooser: View {
    @ObservedObject var document: EmojiArtDocument

    @Binding var chosenPalette: String

    @State private var showPaletteEditor = false

    var body: some View {
        HStack {
            Stepper(
                onIncrement: {
                    chosenPalette = document.palette(after: chosenPalette)
                },
                onDecrement: {
                    chosenPalette = document.palette(before: chosenPalette)
                },
                label: {
                    EmptyView()
                })
            Text(document.paletteNames[chosenPalette] ?? "")
            Image(systemName: "keyboard").imageScale(.large)
                .onTapGesture {
                    showPaletteEditor = true
                }
                .popover(isPresented: $showPaletteEditor) {
                    PaletteEditor(chosenPalette: $chosenPalette)
                        .environmentObject(document)
                        .frame(minWidth: 200, minHeight: 200)
                }
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

struct PaletteEditor: View {
    @EnvironmentObject var document: EmojiArtDocument

    @Binding var chosenPalette: String

    @State private var paletteName: String = ""

    var body: some View {
        VStack {
            Text("Palette Editor")
                .font(.headline)
                .padding()
            Divider()
            TextField("Palette name", text: $paletteName) { began in
                if !began {
                    document.renamePalette(chosenPalette, to: paletteName)
                }
            }
            Spacer()
        }
        .onAppear {
            paletteName = document.paletteNames[chosenPalette] ?? ""
        }
    }
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(document: EmojiArtDocument(), chosenPalette: Binding.constant(""))
    }
}
