//
//  ContentView.swift
//  VisualizerTask
//
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @ObservedObject var audioManager = AudioManager.shared
    @State private var drawingHeight = false
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 50) {
            Spacer()
            HStack(spacing: 4) {
                ForEach(0..<12, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.indigo)
                        .frame(width: 6, height: audioManager.levels[index])
                        .animation(.easeInOut(duration: 0.1), value: audioManager.levels[index])
                }
            }
            
            Spacer()
            
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
            withAnimation(.easeInOut(duration: 0.25)) {
                audioManager.levels = (0..<12).map { _ in CGFloat.random(in: 10...25) }
            }
        }
    }


    func startAnimating() {
        stopAnimating()

        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
            if !drawingHeight {
                stopAnimating()
                return
            }

//            withAnimation(.easeInOut(duration: 0.25)) {
//                audioManager.levels = (0..<12).map { _ in CGFloat.random(in: 10...25) }
//            }
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
