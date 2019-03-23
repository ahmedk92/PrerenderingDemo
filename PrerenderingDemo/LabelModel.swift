//
//  LabelModel.swift
//  PrerenderingDemo
//
//  Created by Ahmed Khalaf on 3/22/19.
//  Copyright © 2019 Ahmed Khalaf. All rights reserved.
//

import UIKit

struct LabelModel {
    var attributedString: NSAttributedString {
        didSet {
            render()
        }
    }
    
    private(set) var size: CGSize
    private(set) var image: UIImage?
    
    init(attributedString: NSAttributedString, width: CGFloat) {
        self.attributedString = attributedString
        self.size = CGSize(width: width, height: .greatestFiniteMagnitude)
        render()
    }
}

// MARK: Rendering
extension LabelModel {
     mutating func render() {
        let boundingRect = attributedString.boundingRect(with: size, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil)
        size = boundingRect.size
        autoreleasepool { () -> Void in
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            
            attributedString.draw(in: boundingRect)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
    }
}
