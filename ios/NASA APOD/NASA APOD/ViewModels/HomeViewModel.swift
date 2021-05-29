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
        guard let apod = self.isAvailableInPreferences() else {
            self.apodBlock = block
            self.checkReachabilityAndRequest()
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
    
    func isNewApodAvailable() -> Bool {
        guard let date = AppPreferences.shared.lastSeenApodDate else {
            return false
        }
        
        guard !date.isToday() else {
            return false
        }
        
        return true
    }
    
    private func isAvailableInPreferences() -> APOD? {
        guard let date = AppPreferences.shared.lastSeenApodDate else {
            return nil
        }
        
        guard date.isToday() else {
            return nil
        }
        
        self.apod = AppPreferences.shared.apodInfo
        return self.apod
    }
    
    private func checkReachabilityAndRequest() {
        if NetworkServiceManager.shared.isHostReachable() {
            self.requestAPOD()
        } else {
            self.apod = AppPreferences.shared.apodInfo
            var message = "We are not connected to the internet, showing you the last image we have."
            if self.apod == nil {
                message = "We are not connected to the internet"
            }
            self.apodBlock?(self.apod, message)
        }
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
