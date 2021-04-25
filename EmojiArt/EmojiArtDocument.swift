//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by bogdanov on 22.04.21.
//

import Combine
import SwiftUI

class EmojiArtDocument: ObservableObject {
    static let palette: String = "❤️🎎✈️🏡🐥🏄🤡"

    var emojis: [EmojiArt.Emoji] {
        emojiArt.emojis
    }

    @Published
    private(set) var backgroundImage: UIImage?

    private static let USER_DEFAULTS_DOCUMENT = "USER_DEFAULTS_DOCUMENT"

    @Published
    private var emojiArt: EmojiArt

    private var autosaveCancellable: AnyCancellable?

    init() {
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.USER_DEFAULTS_DOCUMENT)) ?? EmojiArt()

        autosaveCancellable = $emojiArt.sink { emojiArt in
            print("\(emojiArt.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.USER_DEFAULTS_DOCUMENT)
        }

        fetchBackgroundImageData()
    }

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

    var backgroundURL: URL? {
        set {
            emojiArt.backgroundURL = newValue?.imageURL
            fetchBackgroundImageData()
        }
        get {
            emojiArt.backgroundURL
        }
    }

    private var fetchImageCancellable: AnyCancellable?

    private func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = emojiArt.backgroundURL {
            fetchImageCancellable?.cancel()

            fetchImageCancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map { data, _ in UIImage(data: data) }
                .receive(on: DispatchQueue.main)
                .replaceError(with: nil)
                .assign(to: \.backgroundImage, on: self)
        }
    }
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat {
        CGFloat(size)
    }

    var location: CGPoint {
        CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
}
