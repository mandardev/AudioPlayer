//
//  ViewController.swift
//  MediaPlayer
//
//  Created by Mandar Choudhary on 10/11/19.
//  Copyright © 2019 Mandar Choudhary. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioPlayerDelegate {
    
    @IBOutlet weak var previousBtn: UIButton!
    var audioPlayer : AVAudioPlayer?
    let arrayOfSongs : [String] = ["Saki Saki","Jogi","Bekhayali"]
    var currentSongIndex : Int = 0
    let PAUSE_ICON : String = "f"
    let PLAY_ICON : String = "e"
    let NEXT_ICON : String = "d"
    let PREV_ICON : String = "a"
    let BTN_CORNER_RADIUS : CGFloat = 15
    let BTN_BORDER_WIDTH : CGFloat = 1

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var currentTimeLbl: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpAudioPlayerWithResource(resource: arrayOfSongs[0])
        self.initialSetUp()
    }
    
    func setUpAudioPlayerWithResource(resource : String) {
        do{
            audioPlayer = try AVAudioPlayer.init(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: resource, ofType: ".mp3")!, isDirectory: true), fileTypeHint: "")
        }catch{
            print(error)
        }
        audioPlayer?.delegate = self
        audioPlayer!.prepareToPlay()
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        slider.maximumValue = Float(audioPlayer!.duration)
        totalTimeLabel.text = totalTimeLabel.getTimeString(from: Double(slider!.maximumValue))
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(sliderTapped(gestureRecognizer:)))
        self.slider.addGestureRecognizer(tapGestureRecognizer)
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
    
// MARK:- Actions For Media Controls

    @IBAction func previousBtnAction(_ sender: Any) {
        currentSongIndex = currentSongIndex-1
        self.updateView()
        self.setUpAudioPlayerWithResource(resource: arrayOfSongs[currentSongIndex])
        audioPlayer?.play()
        playBtn.setTitle(PAUSE_ICON, for: .normal)
    }
    
    @IBAction func playBtnAction(_ sender: Any) {
        if audioPlayer!.isPlaying{
            audioPlayer?.pause()
            playBtn.setTitle(PLAY_ICON, for: .normal)
        }else{
            audioPlayer?.play()
            playBtn.setTitle(PAUSE_ICON, for: .normal)
        }
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        self.actionForNextBrn()
    }
    
    @IBAction func sliderTouchAction(_ sender: Any) {
        audioPlayer!.stop()
        audioPlayer!.currentTime = TimeInterval(slider.value)
        audioPlayer!.prepareToPlay()
        audioPlayer!.play()
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
    
    func actionForNextBrn() {
         currentSongIndex = currentSongIndex+1
         self.updateView()
         self.setUpAudioPlayerWithResource(resource: arrayOfSongs[currentSongIndex])
         audioPlayer?.play()
         playBtn.setTitle(PAUSE_ICON, for: .normal)
    }
    
    func actionForSliderChange() {
        audioPlayer!.stop()
        audioPlayer!.currentTime = TimeInterval(slider.value)
        audioPlayer!.prepareToPlay()
        audioPlayer!.play()
        playBtn.setTitle(PAUSE_ICON, for: .normal)
    }
    
    @objc func updateSlider() {
        slider.value = Float(audioPlayer!.currentTime)
        currentTimeLbl.text = currentTimeLbl.getTimeString(from: Double(slider!.value))
    }
    
// MARK:- Audio Player Delegate Methos
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if (currentSongIndex != arrayOfSongs.count-1){
            self.actionForNextBrn()

        }else{
            playBtn.setTitle(PLAY_ICON, for: .normal)
        }
    }
}

extension UILabel{

    func getTimeString(from duration:Double) -> String{
        let hours   = Int(duration / 3600)
        let minutes = Int(duration / 60) % 60

        let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours,minutes,seconds])
        }else {
            return String(format: "%02i:%02i", arguments: [minutes,seconds])
        }
    }
}

