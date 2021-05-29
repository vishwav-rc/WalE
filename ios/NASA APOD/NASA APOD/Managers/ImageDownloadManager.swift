//
//  ImageManager.swift
//  NASA APOD
//
//  Created by Vishwanath Vallamkondi on 29/05/21.
//

import Foundation
import UIKit

protocol ImageDownloadManagerDelegate {
    func imageDownloadedSuccessfully()
    func imageDownloadingFailed(message:String)
}

class ImageDownloadManager {
    static let shared = ImageDownloadManager()
    var delegate:ImageDownloadManagerDelegate?
    var image:UIImage?
    
    private init() {
        
    }
        
    private func downloadImage(url:URL) {
        DispatchQueue.global(qos: .background).async {
            do {
                AppLog(message: "Image downloading started")
                let data = try Data(contentsOf: url)
                guard !data.isEmpty else {
                    self.delegate?.imageDownloadingFailed(message: "Image not found")
                    return
                }
                
                let image = UIImage(data: data)
                self.image = image
                AppLog(message: "Image downloading completed")
                self.delegate?.imageDownloadedSuccessfully()
            } catch (let error) {
                self.delegate?.imageDownloadingFailed(message: error.localizedDescription)
            }
        }
    }
}

extension ImageDownloadManager {
    public func downloadImage(urlString:String) {
        guard let url = URL(string: urlString) else {
            self.delegate?.imageDownloadingFailed(message: "Not a valid url")
            return
        }
        
        self.downloadImage(url: url)
    }
}
