//
//  ImageLoader.swift
//  ScrollableGrid
//
//  Created by Priyank Gandhi on 12/05/24.
//

import Foundation
import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    
    private let cache = LRUCache<String, UIImage>()
    private let fileManager = FileManager.default
    private var diskCacheURL: URL {
        let cacheDirectory = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return cacheDirectory.appendingPathComponent("imageCache")
    }
    
    private (set) var loadingTasks: [URLSessionTask] = []
    private var visibleIndexPaths: Set<IndexPath> = []
    
    private init() {
        do {
            try fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func imageLoadingWith(urlString strURL: String,for indexPath: IndexPath, completion: @escaping (UIImage?) -> Void) {
        
        if let image = cache.value(forKey: strURL) {
            completion(image)
            return
        }
        
        
        // Check in cache disk
        let filePath = getFilePath(forKey: strURL)
        if let imageData = fileManager.contents(atPath: filePath.path), let image = UIImage(data: imageData) {
            cache.setValue(image, forKey: strURL, cost: imageData.count)
            completion(image)
            return
        }
        
        // Fetch image from network
       let task = URLSession.shared.dataTask(with: URL(string: strURL)!) {[weak self] data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                print("Image loading error:", error?.localizedDescription ?? "")
                completion(nil)
                return
            }
           // Resize and compress image
           let resizedImage = self?.resizeAndCompress(imageWidth: 170.0, image: image)
           
           self?.cache.setValue(resizedImage, forKey: strURL, cost: data.count)
            try? data.write(to: filePath, options: .atomic)
            completion(resizedImage)
        }
        
        task.resume()
        
        loadingTasks.append(task)
    }
    
    
    private func getFilePath(forKey key: String) -> URL {
        return diskCacheURL.appendingPathComponent("\(key)")
    }
    
    private func resizeAndCompress(imageWidth width:CGFloat, image: UIImage) -> UIImage? {
        // Resize image to appropriate size
        let targetSize = CGSize(width: width, height: width)
        UIGraphicsBeginImageContext(targetSize)
        image.draw(in: CGRect(origin: .zero, size: targetSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Compress image
        guard let compressedData = resizedImage?.jpegData(compressionQuality: 0.8) else { return nil }
        return UIImage(data: compressedData)
    }
    
}
