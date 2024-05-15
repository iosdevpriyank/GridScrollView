//
//  ImageCollectionViewCell.swift
//  ScrollableGrid
//
//  Created by Priyank Gandhi on 12/05/24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.layer.borderWidth = 1.0
        imgView.layer.borderColor = UIColor.gray.cgColor
        imgView.clipsToBounds = true
        
    }
    
    func setupCellConfiguration(imageURL strURL: String,for indexPath: IndexPath) {
        self.imagePlaceHolder()
        ImageLoader.shared.imageLoadingWith(urlString: strURL, for: indexPath) { [weak self] image in
            if let image = image {
                DispatchQueue.main.async {
                    self?.imgView.removeSymbolEffect(ofType: .bounce)
                    self?.imgView.contentMode = .scaleAspectFill
                    self?.imgView.image = image.centerCroppedImage(size: self?.imgView.frame.size ?? .zero)
                }
            } else {
                // Image placeHolder
                self?.imagePlaceHolder()
            }
        }
    }
    
    private func imagePlaceHolder() {
        if (UIImage(systemName: "photo.artframe")?.withRenderingMode(.alwaysTemplate)) != nil {
            DispatchQueue.main.async { [weak self] in
                self?.imgView.image = UIImage(systemName: "photo.artframe")
                self?.imgView.addSymbolEffect(.bounce)
            }
        }
    }
}


