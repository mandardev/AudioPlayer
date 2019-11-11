//
//  ViewController.swift
//  MediaPlayer
//
//  Created by Mandar Choudhary on 10/11/19.
//  Copyright © 2019 Mandar Choudhary. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var previousBtn: UIButton!
    var audioPlayer : AVAudioPlayer?
    let arrayOfSongs : [String] = ["Saki Saki","Jogi","Bekhayali"]
    var currentSongIndex : Int = 0
    let PLAY_ICON : String = "f"
    let PAUSE_ICON : String = "e"
    let NEXT_ICON : String = "d"
    let PREV_ICON : String = "a"
    let BTN_CORNER_RADIUS : CGFloat = 15
    let BTN_BORDER_WIDTH : CGFloat = 1

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpAudioPlayerWithResource(resource: arrayOfSongs[0])
        self.initialSetUp()
    }
    
    func initialSetUp() {
        self.updateView()
        playBtn.layer.cornerRadius = BTN_CORNER_RADIUS
        nextBtn.layer.cornerRadius = BTN_CORNER_RADIUS
        previousBtn.layer.cornerRadius = BTN_CORNER_RADIUS
        
        playBtn.layer.borderWidth = BTN_BORDER_WIDTH
        nextBtn.layer.borderWidth = BTN_BORDER_WIDTH
        previousBtn.layer.borderWidth = BTN_BORDER_WIDTH

        playBtn.layer.borderColor = UIColor.white.cgColor
        nextBtn.layer.borderColor = UIColor.white.cgColor
        previousBtn.layer.borderColor = UIColor.white.cgColor
    }

    @IBAction func previousBtnAction(_ sender: Any) {
        currentSongIndex = currentSongIndex-1
        self.updateView()
        self.setUpAudioPlayerWithResource(resource: arrayOfSongs[currentSongIndex])
        audioPlayer?.play()
        playBtn.setTitle(PLAY_ICON, for: .normal)
    }
    
    @IBAction func playBtnAction(_ sender: Any) {
        if audioPlayer!.isPlaying{
            audioPlayer?.pause()
            playBtn.setTitle(PAUSE_ICON, for: .normal)
        }else{
            audioPlayer?.play()
            playBtn.setTitle(PLAY_ICON, for: .normal)
        }
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        currentSongIndex = currentSongIndex+1
        self.updateView()
        self.setUpAudioPlayerWithResource(resource: arrayOfSongs[currentSongIndex])
        audioPlayer?.play()
        playBtn.setTitle(PLAY_ICON, for: .normal)
    }
    
    func updateView() {
        switch currentSongIndex {
        case arrayOfSongs.count-1:
            nextBtn.isUserInteractionEnabled = false
            nextBtn.alpha = 0.5
            
        case 0:
            previousBtn.isUserInteractionEnabled = false
            previousBtn.alpha = 0.5
        default:
            nextBtn.alpha = 1
            previousBtn.isUserInteractionEnabled = true
            previousBtn.alpha = 1
            nextBtn.isUserInteractionEnabled = true
            nextBtn.alpha = 1
        }
    }
    
    func setUpAudioPlayerWithResource(resource : String) {
        do{
            audioPlayer = try AVAudioPlayer.init(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: resource, ofType: ".mp3")!, isDirectory: true), fileTypeHint: "")
        }catch{
            print(error)
        }
        audioPlayer!.prepareToPlay()
    }
}

