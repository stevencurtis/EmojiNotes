//
//  NotesCollectionViewCell.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 21/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

class NotesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cross: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.view.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(title: String, colour: UIColor, emoji: String? = nil, image: UIImage? = nil) {
        titleLabel.text = emoji ?? "no emoji" + " " + title
        imageView.image = image
        view.backgroundColor = colour
        
        let textColor = colour.isDarkColor ? UIColor.white : UIColor.black
        titleLabel.textColor = textColor
        cross.isHidden = true
    }
    
    func shake() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 2
        shakeAnimation.autoreverses = true
        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle
        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.15
        shakeAnimation.repeatCount = 10000
        shakeAnimation.timeOffset = 290 * drand48()
        
        let layer: CALayer = self.layer
        layer.add(shakeAnimation, forKey:"shaking")
        
        cross.isHidden = false
    }
    
    
    func stopShaking() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "shaking")
        cross.isHidden = true
    }

}
