//
//  Spinning.swift
//  EmojiArt
//
//  Created by bogdanov on 25.04.21.
//

import SwiftUI

struct Spinning: ViewModifier {
    @State var isVisible = false

    func body(content: Content) -> some View {
        content.rotationEffect(Angle(degrees: isVisible ? 360 : 0))
            .animation(Animation.linear(duration: 1).repeatForever())
            .onAppear {
                isVisible = true
            }
    }
}

extension View {
    func spinning() -> some View {
        modifier(Spinning())
    }
}
