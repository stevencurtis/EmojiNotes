//
//  CreateNoteViewController.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 21/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

protocol CreateNoteDelegate {
    func provImage( _ img: UIImage)
}

class CreateNoteViewController: UIViewController, CreateNoteDelegate {
    var image : UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
    func provImage(_ img: UIImage) {
        image = img
        
        imageView.image = img
    }
    
    // selectImg
    
    @IBAction func attachImg(_ sender: UIButton) {
        performSegue(withIdentifier: "selectImg", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectImg" {
            if let destination = segue.destination as? AttachPhotoViewController {
                destination.noteDelegate = self
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func attachImage(_ sender: UIButton) {
    }
    


}
