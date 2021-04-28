//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by bogdanov on 22.04.21.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    let store = EmojiArtDocumentStore(named: "Creative Emoji Art")
//        .addDocument(named: "Doc 1").addDocument(named: "Doc 2")

    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentChooser().environmentObject(store)
//            EmojiArtDocumentView(document: EmojiArtDocument())
        }
    }
}
