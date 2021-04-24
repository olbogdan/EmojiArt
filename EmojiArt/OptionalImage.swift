//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by bogdanov on 24.04.21.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?

    var body: some View {
        Group {
            if let image = uiImage {
                Image(uiImage: image)
            }
        }
    }
}
