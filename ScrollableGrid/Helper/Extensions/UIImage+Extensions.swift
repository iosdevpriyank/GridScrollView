//
//  UIImage+Extensions.swift
//  ScrollableGrid
//
//  Created by Priyank Gandhi on 12/05/24.
//

import UIKit
import Foundation


extension UIImage {
    func centerCroppedImage(size: CGSize) -> UIImage? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        
        let contextImage: UIImage = UIImage(cgImage: cgImage)
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var width: CGFloat = size.width
        var height: CGFloat = size.height
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            width = contextSize.height
            height = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            width = contextSize.width
            height = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: width, height: height)
        
        // Create bitmap image from context using the rect
        guard let imageRef = cgImage.cropping(to: rect) else {
            return nil
        }
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let croppedImage: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        
        return croppedImage
    }
}
