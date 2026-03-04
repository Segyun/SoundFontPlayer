//
//  ContentView.swift
//  SoundFontPlayer
//
//  Created by Huigyun Jeong on 3/4/26.
//

import SwiftUI

struct ContentView: View {
    @State private var player: SoundFontPlayer = .init()
    @State private var selectedNote: UInt8 = 60

    var body: some View {
        VStack {
            HStack(
                alignment: .top,
                spacing: -16
            ) {
                ForEach(60..<72 as Range<UInt8>, id: \.self) { note in
                    PianoKeyView(note: note) { pressed in
                        if pressed {
                            player.play(note: note)
                        } else {
                            player.stop(note: note)
                        }
                    }

                    if note % 12 == 4 {
                        PianoKeyView(note: note) { _ in }
                            .hidden()
                    }
                }
            }
            .padding()
            .background(.gray.secondary, in: .rect(cornerRadius: 12))
            .frame(maxHeight: 200)
        }
        .padding()
        .task {
            try? player.prepare()
        }
    }
}

struct PianoKeyView: View {
    let note: UInt8
    let onPressingChanged: (Bool) -> Void

    @State private var isPressed: Bool = false

    private var color: Color {
        if isPressed {
            return .gray
        } else if note.isWhite {
            return .white
        } else {
            return .black
        }
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(color)
            .frame(maxHeight: note.isWhite ? nil : 100)
            .zIndex(note.isWhite ? 0 : 1)
            .onLongPressGesture {
            } onPressingChanged: { pressed in
                withAnimation(.snappy(duration: 0.1)) {
                    self.isPressed = pressed
                }
                onPressingChanged(pressed)
            }
    }
}

extension UInt8 {
    fileprivate var isWhite: Bool {
        switch self % 12 {
        case 0, 2, 4, 5, 7, 9, 11:
            return true
        default:
            return false
        }
    }
}

#Preview {
    ContentView()
}
