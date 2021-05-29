//
//  HomeViewModel.swift
//  NASA APOD
//
//  Created by Vishwanath Vallamkondi on 29/05/21.
//

import Foundation

typealias APODCompletionBlock = (APOD?, String?) -> Void

class HomeViewModel {
    private var apod:APOD?
    var apodBlock:APODCompletionBlock?
    
    func getAPOD(block:APODCompletionBlock?) {
        guard let apod = self.apod else {
            self.apodBlock = block
            self.requestAPOD()
            return
        }
        
        block?(apod, nil)
    }
    
    private func requestAPOD() {
        NetworkServiceManager.shared.getPictureOfTheDay {[weak self] (apod, error) in
            guard let wself = self else {
                return
            }
            wself.apod = apod
            DispatchQueue.main.async {
                wself.apodBlock?(apod, error?.description)
            }
        }
    }
}
