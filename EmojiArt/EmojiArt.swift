//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by bogdanov on 22.04.21.
//

import Foundation

struct EmojiArt: Codable {
    var backgroundURL: URL?
    var emojis = [Emoji]()
    var json: Data? { try? JSONEncoder().encode(self) }
    private var uniqueEmojiId = 0

    init() {}

    init?(json: Data?) {
        if json != nil, let newEmojiArt = try? JSONDecoder().decode(EmojiArt.self, from: json!) {
            self = newEmojiArt
        } else {
            return nil
        }
    }

    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
        uniqueEmojiId += 1
        let emoji = Emoji(text: text, x: x, y: y, size: size, id: uniqueEmojiId)
        emojis.append(emoji)
    }

    struct Emoji: Identifiable, Codable {
        let text: String
        var x: Int // offset from the center
        var y: Int // offset from the center
        var size: Int
        let id: Int

        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
}
