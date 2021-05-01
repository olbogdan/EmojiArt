//
//  EmojiArtDocumentChooser.swift
//  EmojiArt
//
//  Created by bogdanov on 28.04.21.
//

import SwiftUI

struct EmojiArtDocumentChooser: View {
    @EnvironmentObject var store: EmojiArtDocumentStore

    var body: some View {
        NavigationView {
            List {
                ForEach(store.documents) { document in
                    NavigationLink(destination: EmojiArtDocumentView(document: document)
                        .navigationBarTitle(store.name(for: document))) {
                            Text(store.name(for: document))
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { store.documents[$0] }.forEach { document in
                        store.removeDocument(document)
                    }
                }
            }
            .navigationBarTitle(store.name)
            .navigationBarItems(
                leading: Button(action: { store.addDocument() },
                                label: { Image(systemName: "plus").imageScale(.large) }))
        }
    }
}

struct EmojiArtDocumentChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentChooser()
    }
}
