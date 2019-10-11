//
//  ImageLoader.swift
//
//
//  Created by Suraj Pathak
//  Copyright © 2016 Suraj Pathak. All rights reserved.
//

import UIKit

/// A quick image loader from a url string, with a simple caching mechanism
class ImageLoader {
    typealias ImageBlock = ((UIImage?) -> Void)
    static let shared = ImageLoader()
    private var cachedImages: [String: UIImage] = [:]
    
    private init() {}
    
    /// Loads image from a url string asynchronously. It caches the image temporarily in a cachel
    func loadImage(from urlString: String, completion: @escaping ImageBlock) {
        if let cached = cachedImages[urlString] {
            completion(cached)
            return
        }
        
        DispatchQueue(label: "com.image.news").async {
            guard let url = URL(string: urlString),
                let data = try? Data(contentsOf: url) else {
                    DispatchQueue.main.async { completion(nil) }
                    return
            }
            let image = UIImage(data: data)
            if let validImage = image {
                DispatchQueue.main.async { self.cachedImages[urlString] = validImage }
            }
            DispatchQueue.main.async { completion(image) }
        }
    }
    
}
