//
//  LocalStorageManager.swift
//  NASA APOD
//
//  Created by Vishwanath Vallamkondi on 29/05/21.
//

import Foundation
import UIKit

class LocalStorageManager {
    static let shared = LocalStorageManager()
    
    private var apodURL : URL? = {
        var url = URL.init(fileURLWithPath: NSHomeDirectory(), isDirectory: true).appendingPathComponent("APOD", isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return nil
        }
        return url
    }()

    private func saveImageData(data:Data, name:String) {
        guard let fileURL = self.apodURL?.appendingPathComponent(name, isDirectory: false) else {
            return
        }
        
        guard !FileManager.default.fileExists(atPath: fileURL.path) else {
            AppLog(message: "File already exists")
            return
        }

        do {
            try data.write(to: fileURL)
        } catch (let error) {
            AppLog(message: "Failed to save image:\(name) error:\(error.localizedDescription)")
        }
    }
    
    private func getImageData(name:String) -> Data? {
        guard let fileURL = self.apodURL?.appendingPathComponent(name, isDirectory: false) else {
            return nil
        }
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            AppLog(message: "File doesn't exists")
            return nil
        }

        return try? Data(contentsOf: fileURL)
    }
}

extension LocalStorageManager {
    public func saveImageDataWithName(data:Data, name:String) {
        DispatchQueue.global(qos: .background).async {
            self.saveImageData(data: data, name: name)
        }
    }
    
    public func getImageWithName(name:String) -> UIImage? {
        guard let imageData = self.getImageData(name: name) else {
            return nil
        }
        
        return UIImage(data: imageData)
    }
}
