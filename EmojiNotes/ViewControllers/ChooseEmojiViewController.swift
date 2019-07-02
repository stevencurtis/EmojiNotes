//
//  ChooseEmojiViewController.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 26/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

class ChooseEmojiViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var emojiList: [String] = []
    let emojiRange = (0x1F601...0x1F64F)
    var delegate : ChosenEmojiDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
            var array: [String] = []
            for i in emojiRange {
                if let unicodeScalar = UnicodeScalar(i) {
                    array.append(String(describing: unicodeScalar))
                }
            }
            
        emojiList = (array)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nib = UINib(nibName: "EmojiCollectionViewCell", bundle: nil);
        collectionView.register(nib, forCellWithReuseIdentifier: "EmojiCollectionViewCell")
    }
}

extension ChooseEmojiViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCollectionViewCell", for: indexPath) as! EmojiCollectionViewCell
        cell.imageView.image = emojiList[indexPath.row].image()
        return cell

    }
}

extension ChooseEmojiViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.chosenEmoji(emojiList[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}


