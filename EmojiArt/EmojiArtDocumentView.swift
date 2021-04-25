//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by bogdanov on 22.04.21.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument

    @State private var steadyStateZoomScale: CGFloat = 1.0

    @GestureState private var gestureZoomScale: CGFloat = 1.0

    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }

    private let defaultEmojiSize: CGFloat = 40

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
                ZStack {
                    Color.white.overlay(
                        OptionalImage(uiImage: self.document.backgroundImage)
                            .scaleEffect(zoomScale)
                    )
                    .gesture(self.doubleTapToZoom(in: geometry.size))
                    if isLoading {
                        Image(systemName: "hourglass").imageScale(.large).spinning()
                    } else {
                        ForEach(document.emojis) { emoji in
                            Text(emoji.text)
                                .font(animatableWithSize: emoji.fontSize * zoomScale)
                                .position(position(for: emoji, in: geometry.size))
                        }
                    }
                }
                .clipped()
                .gesture(zoomGesture())
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onReceive(document.$backgroundImage) { image in
                    zoomToFit(image, in: geometry.size)
                }
                .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                    var location = geometry.convert(location, from: .global)
                    location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                    location = CGPoint(x: location.x/zoomScale, y: location.y/zoomScale)
                    return drop(providers: providers, at: location)
                }
            }
        }
    }

    var isLoading: Bool {
        document.backgroundURL != nil && document.backgroundImage == nil
    }

    private func zoomGesture() -> some Gesture {
        return MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, ourGestureStateInOut, _ in
                ourGestureStateInOut = latestGestureScale
            }
            .onEnded { finalGestureScale in
                steadyStateZoomScale *= finalGestureScale
            }
    }

    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    zoomToFit(document.backgroundImage, in: size)
                }
            }
    }

    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        return CGPoint(x: location.x + size.width/2, y: location.y + size.height/2)
    }

    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            print("dropped  \(url)")
            document.backgroundURL = url
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                document.addEmoji(string, at: location, size: defaultEmojiSize)
            }
        }

        return found
    }

    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0 {
            let hZoom = size.width/image.size.width
            let vZoom = size.height/image.size.height
            steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
}
