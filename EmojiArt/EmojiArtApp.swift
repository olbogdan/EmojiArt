//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by bogdanov on 22.04.21.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: EmojiArtDocument())
        }
    }
}
