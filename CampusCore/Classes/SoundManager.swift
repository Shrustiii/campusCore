////
////  SoundManager.swift
////  CampusCore
////
////  Author: Harshpreet Singh
////  Description:
////  Handles audio playback for user feedback events in the application.
////
//
//import UIKit
//import Foundation
//import AVFoundation
//
//class SoundManager: NSObject {
//
//    static let shared = SoundManager()
//    private var player: AVAudioPlayer?
//    
//    private override init() {}
//    
//    /*
//     Method: playCompletionSound
//     Author: Harshpreet Singh
//     Purpose:
//     Plays a short success sound when an assignment is marked complete.
//    */
//    func playCompletionSound() {
//        guard let url = Bundle.main.url(forResource: "complete", withExtension: "wav") else {
//            print("Sound file not found.")
//            return
//        }
//        
//        do {
//            player = try AVAudioPlayer(contentsOf: url)
//            player?.play()
//        } catch {
//            print("Unable to play sound: \(error.localizedDescription)")
//        }
//    }
//}


//
//  SoundManager.swift
//  CampusCore
//
//  Author: Dhruvi Jariwala
//  Description:
//  Plays short sound effects used in the app.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static let shared = SoundManager()
    
    var audioPlayer: AVAudioPlayer?
    
    private init() { }
    
    func playSound(fileName: String, fileType: String) {
        
        if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
            let url = URL(fileURLWithPath: path)
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("ERROR: Could not play sound.")
            }
        } else {
            print("ERROR: Sound file not found.")
        }
    }
}
