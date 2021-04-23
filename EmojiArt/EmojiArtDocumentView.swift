//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by bogdanov on 22.04.21.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument

    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    let data = EmojiArtDocument.palette.map { String($0) }
                    ForEach(data, id: \.self) { emoji in
                        Text(emoji).font(Font.system(size: defaultEmojiSize))
                    }
                }
            }
            .padding(.horizontal)
            Rectangle().foregroundColor(.white).overlay(
                Group {
                    if let image = self.document.backgroundImage {
                        Image(uiImage: image)
                    }
                }
            )
            .edgesIgnoringSafeArea([.horizontal, .bottom])
            .onDrop(of: ["public.image"], isTargeted: nil) { providers, _ in
                drop(providers: providers)
            }
        }
    }

    private func drop(providers: [NSItemProvider]) -> Bool {
        let found = providers.loadFirstObject(ofType: URL.self) { url in
            print("dropped  \(url)")
            document.setBackgroundURL(url)
        }
        return found
    }

    private let defaultEmojiSize: CGFloat = 40
}
