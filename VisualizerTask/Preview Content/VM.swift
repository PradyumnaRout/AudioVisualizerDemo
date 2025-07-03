//
//  VM.swift
//  VisualizerTask
//
//

import Foundation

//Ref - https://medium.com/better-programming/audio-visualization-in-swift-using-metal-accelerate-part-1-390965c095d7
/**
 private var bufferSize: AVAudioFrameCount = 1024
 
 -> Frame = [sample_left, sample_right]
    So frame is power of 2, so this size allows faster and efficient signal.
 
 
 engine.mainMixerNode.removeTap(onBus: 0)
 onBus - path ways of audio node.
 onBus: 0 means installing the tap on bus 0 (usually the first and only output).
 
 bus 1 if the node has at least 2 input or output buses.
 bus 2 if the node has at least 3 input or output buses.
 
 */
