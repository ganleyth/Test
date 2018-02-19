//
//  AVAudioPlayer+Helpers.swift
//  Jetman
//
//  Created by Thomas Ganley on 2/18/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import AVFoundation

extension AVAudioPlayer {
    static var propulsionSoundLoopPlayer: AVAudioPlayer? {
        guard let urlString = Bundle.main.path(forResource: "bubblePop", ofType: ".wav") else {
            Logger.error("Could not get path for jetpack loop sound.", filePath: #file, funcName: #function, lineNumber: #line)
            return nil
        }
        
        let player: AVAudioPlayer
        do {
            let url = URL(fileURLWithPath: urlString)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
        } catch {
            Logger.error("Error creating audio player: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
            return nil
        }
        
        player.numberOfLoops = -1
        player.volume = 0.3
        player.prepareToPlay()
        return player
    }
}
