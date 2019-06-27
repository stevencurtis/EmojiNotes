//
//  NotesCollectionViewCell.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 21/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

class NotesCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8
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
    }

}
