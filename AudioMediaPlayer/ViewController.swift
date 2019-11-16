//
//  ViewController.swift
//  MediaPlayer
//
//  Created by Mandar Choudhary on 10/11/19.
//  Copyright © 2019 Mandar Choudhary. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController,CustomAudioPlayerDelagate {

    @IBOutlet weak var previousBtn: UIButton!
    var customAudioPlayer : AudioPlayerController?
    let arrayOfSongs : [String] = ["Saki Saki","Jogi","Bekhayali","Duniyaa (Luka Chuppi)","Tukur Tukur (Dilwale)"]
    let PAUSE_ICON : String = "f"
    let PLAY_ICON : String = "e"
    let NEXT_ICON : String = "d"
    let PREV_ICON : String = "a"
    let BTN_CORNER_RADIUS : CGFloat = 15
    let BTN_BORDER_WIDTH : CGFloat = 1
    var audioTimer : Timer?

    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var audioImageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var currentTimeLbl: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customAudioPlayer = AudioPlayerController.init(audios: arrayOfSongs)
        customAudioPlayer?.delegate=self
        self.initialSetUp()
    }
    
// MARK:- SetUp View Methods : 
    
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
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(sliderTapped(gestureRecognizer:)))
        self.slider.addGestureRecognizer(tapGestureRecognizer)
        self.getAndSetMetadataForAudio()
    }
    
    func activateTimer() {
        if(audioTimer == nil){
            audioTimer =  Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        }
    }
    
    func deactivateTimer() {
        audioTimer = nil
    }
    
    func getAndSetMetadataForAudio() {
        for item in (customAudioPlayer!.playerItem?.asset.metadata)! {
            if let stringValue = item.value as? String, let _ = item.commonKey {
                if item.commonKey!.rawValue == "title" {
                    print(stringValue)
                    songTitle.text=stringValue
                }
                if item.commonKey!.rawValue == "artist" {
                    print(stringValue)
                }
            }
            if let _ = item.commonKey {
                if item.commonKey!.rawValue == "artwork" {
                    if let audioImage = UIImage(data: item.value as! Data) {
                        print(audioImage.description)
                        audioImageView.image = audioImage
                    }
                }
            }
        }
    }
    
    func updateView() {
        switch customAudioPlayer?.currentAudioIndex {
            
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
        
        slider.maximumValue = Float(customAudioPlayer!.player!.duration)
        totalTimeLabel.text = totalTimeLabel.getTimeString(from: Double(slider!.maximumValue))
    }
    
// MARK:- Actions For Media Controls

    @IBAction func previousBtnAction(_ sender: Any) {
        customAudioPlayer?.playPreviousAudio()
        self.actionAfterSongChange()
    }
    
    @IBAction func playBtnAction(_ sender: Any) {
        if customAudioPlayer!.player!.isPlaying{
            customAudioPlayer?.player!.pause()
            playBtn.setTitle(PLAY_ICON, for: .normal)
            self.deactivateTimer()
        }else{
            customAudioPlayer?.player!.play()
            playBtn.setTitle(PAUSE_ICON, for: .normal)
            self.activateTimer()
        }
        self.activateTimer()
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        self.actionForNextBtn()
    }
    
    @IBAction func sliderTouchAction(_ sender: Any) {
        customAudioPlayer?.playAudioAtValue(value: slider.value)
        playBtn.setTitle(PAUSE_ICON, for: .normal)
    }
    
    @IBAction func sliderChangedAction(_ sender: Any) {
        self.actionForSliderChange()
    }
    
    @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        let pointTapped: CGPoint = gestureRecognizer.location(in: self.view)
        let positionOfSlider: CGPoint = slider.frame.origin
        let widthOfSlider: CGFloat = slider.frame.size.width
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(slider.maximumValue) / widthOfSlider)
        slider.setValue(Float(newValue), animated: true)
        self.actionForSliderChange()
    }
    
    func actionForNextBtn() {
        customAudioPlayer?.playNextAudio()
        self.actionAfterSongChange()
    }
    
    func actionAfterSongChange() {
        playBtn.setTitle(PAUSE_ICON, for: .normal)
        self.activateTimer()
        self.updateView()
        self.getAndSetMetadataForAudio()
    }
    
    func actionForSliderChange() {
        customAudioPlayer?.playAudioAtValue(value: slider.value)
        playBtn.setTitle(PAUSE_ICON, for: .normal)
    }
    
    @objc func updateSlider() {
        slider.value = Float(customAudioPlayer!.player!.currentTime)
        currentTimeLbl.text = currentTimeLbl.getTimeString(from: Double(slider!.value))
    }
    
// MARK:- Audio Player Delegate Methos
    
    func customAudioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if (customAudioPlayer?.currentAudioIndex != arrayOfSongs.count-1){
            self.actionForNextBtn()
        }else{
            playBtn.setTitle(PLAY_ICON, for: .normal)
            self.deactivateTimer()
        }
    }
}

