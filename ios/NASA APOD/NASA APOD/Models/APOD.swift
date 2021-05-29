//
//  APOD.swift
//  NASA APOD
//
//  Created by Vishwanath Vallamkondi on 29/05/21.
//

import Foundation

struct APOD : Codable {
    let date:String
    let title:String
    let explanation:String
    let hdurl:String
    let media_type:String
    let service_version:String
    let url:String    
}
