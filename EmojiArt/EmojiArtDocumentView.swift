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
                        Text(emoji)
                            .onDrag { NSItemProvider(object: emoji as NSString) }
                            .font(Font.system(size: defaultEmojiSize))
                    }
                }
            }
            .padding(.horizontal)
            GeometryReader { geometry in
                Color.white.overlay(
                    Group {
                        if let image = self.document.backgroundImage {
                            Image(uiImage: image)
                        }
                    }
                )
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                    var location = geometry.convert(location, from: .global)
                    location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                    return drop(providers: providers, at: location)
                }
            }
        }
    }

    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            print("dropped  \(url)")
            document.setBackgroundURL(url)
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                document.addEmoji(string, at: location, size: defaultEmojiSize)
            }
        }

        return found
    }

    private let defaultEmojiSize: CGFloat = 40
}
