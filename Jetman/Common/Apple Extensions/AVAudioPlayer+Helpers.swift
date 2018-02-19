//
//  AVAudioPlayer+Helpers.swift
//  Jetman
//
//  Created by Thomas Ganley on 2/18/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import AVFoundation

extension AVAudioPlayer {

    static func audioPlayer(for file: SoundFile, looping: Bool, volumeLevel: VolumeLevel = .medium) -> AVAudioPlayer? {
        guard let urlString = Bundle.main.path(forResource: file.rawValue, ofType: ".wav") else {
            Logger.error("Could not get path for jetpack loop sound.", filePath: #file, funcName: #function, lineNumber: #line)
            return nil
        }
        
        print(urlString)
        
        let player: AVAudioPlayer
        do {
            let url = URL(fileURLWithPath: urlString)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
        } catch {
            Logger.error("Error creating audio player: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
            return nil
        }
        
        player.numberOfLoops = looping ? -1 : 0
        player.volume = volumeLevel.floatValue
        player.prepareToPlay()
        return player
    }
    
    enum SoundFile: String {
        case crash
        case descent
        case music
        case propulsion = "bubblePop"
        case splash
    }
    
    enum VolumeLevel: Int {
        case low = 1
        case medium = 3
        case high = 5
        
        var floatValue: Float {
            return Float(rawValue) / 10.0
        }
    }
}
