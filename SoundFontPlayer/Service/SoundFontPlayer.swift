//
//  SoundFontPlayer.swift
//  SoundFontPlayer
//
//  Created by Huigyun Jeong on 3/4/26.
//

import AVFAudio
import Foundation

enum SoundFontPlayerError: Error {
    case soundBankFileNotFound
}

@Observable
final class SoundFontPlayer {
    private static let velocity: UInt8 = 100
    private static let channel: UInt8 = 0

    private let engine: AVAudioEngine
    private let sampler: AVAudioUnitSampler
    private let sequencer: AVAudioSequencer

    init() {
        self.engine = .init()
        self.sampler = .init()
        self.sequencer = .init(audioEngine: engine)
    }

    func prepare() throws {
        attachNode()
        try loadSoundBank()
        try activateAudioSession()
        try startEngine()
    }

    func play(note: UInt8) {
        sampler.startNote(
            note,
            withVelocity: Self.velocity,
            onChannel: Self.channel
        )
    }

    func stop(note: UInt8) {
        sampler.stopNote(
            note,
            onChannel: Self.channel
        )
    }

    private func attachNode() {
        engine.attach(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)
    }

    private func loadSoundBank() throws {
        guard
            let url = Bundle.main.url(
                forResource: "U20PIANO",
                withExtension: "sf2"
            )
        else { throw SoundFontPlayerError.soundBankFileNotFound }

        try sampler.loadSoundBankInstrument(
            at: url,
            program: 0,
            bankMSB: .init(kAUSampler_DefaultMelodicBankMSB),
            bankLSB: .init(kAUSampler_DefaultBankLSB)
        )
    }

    private func activateAudioSession() throws {
        let session: AVAudioSession = .sharedInstance()

        try session.setCategory(.playback)
        try session.setActive(true)
    }

    private func startEngine() throws {
        guard !engine.isRunning else { return }

        try engine.start()
    }
}
