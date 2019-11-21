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
    
    var audioURL : URL?
    var player : AVAudioPlayer!
    var playerItem : AVPlayerItem?
    var currentTime : TimeInterval?
    var delegate : ViewController?
    
    init(audioURL : URL) {
        super.init(nibName: nil, bundle: nil)
        self.audioURL=audioURL
        self.setUpAudioPlayerWithURL(url: self.audioURL!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
// MARK:- Initialize audioPlayer with Audio
    
    private func setUpAudioPlayerWithURL(url : URL) {
        do{
            player = try AVAudioPlayer.init(contentsOf: url, fileTypeHint: "")
            self.setPlayerItemForURL(url: url)
            player?.delegate = self
            player!.prepareToPlay()
        }catch{
            print(error)
        }
    }
    
// MARK:- Initialize audioPlayer Item with Audio
    
    private func setPlayerItemForURL(url:URL) {
        playerItem = AVPlayerItem.init(url: url)
    }
    
// MARK:- Play Previous Audio
    func playPreviousAudioWithURL(url:URL) {
        audioURL = url
        self.setUpAudioPlayerWithURL(url: audioURL!)
        player?.play()
    }
    
// MARK:- Play Next Audio

    func playNextAudioWithURL(url:URL) {
        audioURL = url
        self.setUpAudioPlayerWithURL(url: audioURL!)
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
