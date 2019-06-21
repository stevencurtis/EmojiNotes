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

}
