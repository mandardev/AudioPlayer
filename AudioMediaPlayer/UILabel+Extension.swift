//
//  UILabel+Extension.swift
//  AudioMediaPlayer
//
//  Created by Mandar Choudhary on 16/11/19.
//  Copyright © 2019 Mandar Choudhary. All rights reserved.
//

import UIKit

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

class UILabel_Extension: UILabel {

    

}
