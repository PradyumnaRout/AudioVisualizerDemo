//
//  AudioManager.swift
//  VisualizerTask
//
//

import Foundation
import AVFoundation

class AudioManager: ObservableObject {
    
    static let shared = AudioManager()
    
    
    private let engine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()    // Play Music by connecting to node.
    private var audioFile: AVAudioFile?
    private var bufferSize: AVAudioFrameCount = 1024
    
    @Published var levels: [CGFloat] = Array(repeating: 0, count: 15)
    
    private init() {
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: nil)
    }
    
    func playMusic(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("Sound file not found")
            return
        }
        
        do {
            audioFile = try AVAudioFile(forReading: url)
            if let file = audioFile {
                playerNode.stop()
                playerNode.scheduleFile(file, at: nil)          // at: nil (start the audio immediately)
                
                try engine.start()
                
                playerNode.play()
                
                installTap()        // Tapping to audio steam and analize realtime frequency.
            }
        } catch {
            
        }
        
    }
    
    func stopPlaying() {
        playerNode.stop()
        engine.stop()
        engine.reset()
    }
    
    private func installTap() {
        // MixtureNode - Adjust Volume (To heard the sound.)
        
        // Remove the previously tap on bus 0
        engine.mainMixerNode.removeTap(onBus: 0)
        
        // Access the live audio data on bus 0
        engine.mainMixerNode.installTap(onBus: 0, bufferSize: bufferSize, format: engine.mainMixerNode.outputFormat(forBus: 0)) { [weak self] buffer, _ in
            guard let self = self else { return }
            
            let channelData = buffer.floatChannelData?[0]
            let frameLength = Int(buffer.frameLength) // Howmany audio frames
            
            
            print("frameLength :: \(frameLength)")
            
            var proxy: Float = 0
            if let data = channelData {
                for i in 0..<frameLength {
                    print("channelData :: \(data[i])")
                    proxy += data[i] * data[i]
                }
                proxy = sqrt(proxy / Float(frameLength))
            }
            
            let height = CGFloat(proxy * 500)
            DispatchQueue.main.async {
                self.levels = (0..<15).map { _ in height * CGFloat.random(in: 0.8...1.2) }
            }
        }
    }
    
    
//    var audioPlayer: AVAudioPlayer?
//    var isPlaying: Bool {
//        return audioPlayer?.isPlaying ?? false
//    }
//    var playbackPosition: TimeInterval = 0
//    
//    func playSound(named name: String) {
//        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
//            print("Sound file not found")
//            return
//        }
//        
//        do {
//            if audioPlayer == nil || !isPlaying {
//                audioPlayer = try AVAudioPlayer(contentsOf: url)
//                audioPlayer?.currentTime = playbackPosition
//                audioPlayer?.prepareToPlay()
//                audioPlayer?.play()
//            } else {
//                print("Audio is already playing.")
//            }
//        } catch {
//            print("Error playing sound: \(error.localizedDescription)")
//        }
//    }
//    
//    func stopPlaying() {
//        if let player = audioPlayer {
//            playbackPosition = player.currentTime
//            player.stop()
//        }
//    }
}
