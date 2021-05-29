//
//  HomeViewModel.swift
//  NASA APOD
//
//  Created by Vishwanath Vallamkondi on 29/05/21.
//

import Foundation
import UIKit

typealias APODCompletionBlock = (APOD?, String?) -> Void

class HomeViewModel {
    private var apod:APOD?
    var apodBlock:APODCompletionBlock?
    
    func getAPOD(block:APODCompletionBlock?) {
        guard let apod = self.apod else {
            guard let apod = self.isAvailableInPreferences() else {
                self.apodBlock = block
                self.requestAPOD()
                return
            }
            block?(apod, nil)
            return
        }
        
        block?(apod, nil)
    }
    
    func getImage() -> UIImage? {
        guard let apod = self.apod else {
            return nil
        }
        
        return LocalStorageManager.shared.getImageWithName(name: apod.title)
    }
    
    private func isAvailableInPreferences() -> APOD? {
        self.apod = AppPreferences.shared.apodInfo
        return self.apod
    }
    
    private func requestAPOD() {
        NetworkServiceManager.shared.getPictureOfTheDay {[weak self] (apod, error) in
            guard let wself = self else {
                return
            }
            wself.apod = apod
            AppPreferences.shared.apodInfo = apod
            AppPreferences.shared.lastSeenApodDate = Date()
            DispatchQueue.main.async {
                wself.apodBlock?(apod, error?.description)
            }
        }
    }
}
