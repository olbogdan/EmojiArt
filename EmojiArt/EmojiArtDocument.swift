//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by bogdanov on 22.04.21.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    static let palette: String = "❤️🎎✈️🏡🐥🏄"

    @Published
    private var emojiArt = EmojiArt()

    @Published
    private(set) var backgroundImage: UIImage?

    // MARRK: - Intents(s)

    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }

    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }

    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }

    func setBackgroundURL(_ url: URL?) {
        emojiArt.backgroundURL = url?.imageURL
        fetchBackgroundImageData()
    }

    func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = emojiArt.backgroundURL {
            DispatchQueue.global(qos: .userInteractive).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.backgroundImage = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
