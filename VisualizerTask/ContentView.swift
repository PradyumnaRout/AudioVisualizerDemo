//
//  ContentView.swift
//  VisualizerTask
//
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @ObservedObject var audioManager = AudioManager.shared
    @State private var drawingHeight = true
    @State private var barHeights: [CGFloat] = Array(repeating: 10, count: 15)
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 50) {
            HStack(spacing: 2) {
                ForEach(0..<15, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.indigo)
                        .frame(width: 5, height: barHeights[index])
//                        .animation(.easeInOut(duration: 0.25), value: barHeights[index])
                        .animation(.easeInOut(duration: 0.1), value: audioManager.levels[index])
                }
            }

            Button {
                drawingHeight.toggle()
                if drawingHeight {
                    playMusic()
                    startAnimating()
                } else {
                    pauseMusic()
                    stopAnimating()
                }
            } label: {
                Image(drawingHeight ? "pause" : "play")
                    .resizable()
                    .frame(width: 45, height: 45)
            }
        }
        .onAppear {
            if drawingHeight { startAnimating() }
        }
        .onDisappear {
            stopAnimating()
        }
    }


    func startAnimating() {
        stopAnimating()

        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
            if !drawingHeight {
                stopAnimating()
                return
            }

            withAnimation(.easeInOut(duration: 0.25)) {
                barHeights = (0..<15).map { _ in CGFloat.random(in: 5...25) }
            }
        }
    }

    func stopAnimating() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Audio Controls

    func playMusic() {
        AudioManager.shared.playMusic(named: "demoAudio")
    }

    func pauseMusic() {
        AudioManager.shared.stopPlaying()
    }
}



#Preview {
    ContentView()
}
