//
//  AudioPlayerController.swift
//  AudioMediaPlayer
//
//  Created by Mandar Choudhary on 14/11/19.
//  Copyright © 2019 Mandar Choudhary. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

// MARK:- Protocol For AudioPlayerController

protocol CustomAudioPlayerDelagate {
    func customAudioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
}

class AudioPlayerController: UIViewController,AVAudioPlayerDelegate {
    
    let arrayOfAudios : [String]
    var player : AVAudioPlayer?
    var playerItem : AVPlayerItem?
    var currentAudioIndex : Int = 0
    var currentTime : TimeInterval?
    var delegate : ViewController?
    
    init(audios : [String]) {
        arrayOfAudios = audios
        super.init(nibName: nil, bundle: nil)
        self.setUpAudioPlayerWithResource(resource: arrayOfAudios[0])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
// MARK:- Initialize audioPlayer with Audio
    
    private func setUpAudioPlayerWithResource(resource : String) {
        do{
            player = try AVAudioPlayer.init(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: resource, ofType: ".mp3")!, isDirectory: true), fileTypeHint: "")
            self.setPlayerItemForResource(resource: resource)
            player?.delegate = self
            player!.prepareToPlay()
        }catch{
            print(error)
        }
    }
    
// MARK:- Initialize audioPlayer Item with Audio
    
    private func setPlayerItemForResource(resource:String) {
        playerItem = AVPlayerItem.init(url: URL(fileURLWithPath: Bundle.main.path(forResource: resource, ofType: ".mp3")!, isDirectory: true))
    }
    
// MARK:- Play Previous Audio
    func playPreviousAudio() {
        currentAudioIndex = currentAudioIndex-1
        self.setUpAudioPlayerWithResource(resource: arrayOfAudios[currentAudioIndex])
        player?.play()
    }
    
// MARK:- Play Next Audio

    func playNextAudio() {
        currentAudioIndex = currentAudioIndex+1
        self.setUpAudioPlayerWithResource(resource: arrayOfAudios[currentAudioIndex])
        player?.play()
    }
    
// MARK:- Play Next Audio With Value time

    func playAudioAtValue(value:Float) {
        player!.stop()
        player!.currentTime = TimeInterval(value)
        player!.prepareToPlay()
        player!.play()
    }
    
// MARK:- Audio Player Finished Playing
    
    internal func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        delegate?.customAudioPlayerDidFinishPlaying(player, successfully: flag)
    }
}
