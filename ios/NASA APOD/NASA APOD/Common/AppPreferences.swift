//
//  AppPreferences.swift
//  NASA APOD
//
//  Created by Vishwanath Vallamkondi on 29/05/21.
//

import Foundation

class AppPreferences {
    static let shared = AppPreferences()

    struct Key {
        static let lastSeenApodDate = "lastSeenApodDate"
        static let apodInfo = "ApodInfo"
    }
    
    fileprivate let defaults = UserDefaults.standard
    let queue = DispatchQueue(label: "com.wale.nasa-apod.preferences")

    private init() {
        
    }
    
    var lastSeenApodDate: Date? {
        get {
            return queue.sync { defaults.object(forKey: Key.lastSeenApodDate) as? Date }
        }
        set {
            queue.sync {
                defaults.set(newValue, forKey: Key.lastSeenApodDate)
                defaults.synchronize()
            }
        }
    }
    
    var apodInfo:APOD? {
        get {
            return queue.sync {
                guard let data = defaults.object(forKey: Key.apodInfo) as? Data else {
                    return nil
                }
                return try? JSONDecoder().decode(APOD.self, from: data)
            }
        }
        set {
            queue.sync {
                if newValue != nil {
                    do {
                        let data = try JSONEncoder().encode(newValue)
                        defaults.set(data, forKey: Key.apodInfo)
                        defaults.synchronize()
                    } catch {
                        AppLog(message: "Failed to save apod")
                    }
                }
            }
        }
    }
}
