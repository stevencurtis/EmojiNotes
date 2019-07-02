//
//  String - image.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 26/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

extension String {
    // for use in drawing the emoji as an image
    func image() -> UIImage? {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        UIColor.clear.set()
        
        let stringBounds = (self as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 75)])
        let originX = (size.width - stringBounds.width)/2
        let originY = (size.height - stringBounds.height)/2
        let rect = CGRect(origin: CGPoint(x: originX, y: originY), size: size)
        UIRectFill(rect)
        (self as NSString).draw(in: rect, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 75)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
