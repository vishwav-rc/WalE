//
//  HelperFunctions.swift
//  NASA APOD
//
//  Created by Vishwanath Vallamkondi on 29/05/21.
//

import Foundation

func AppLog(fileName: String = #file, functionName: String = #function, message:String) {
    let className = fileName.components(separatedBy: "/").last
    #if DEBUG
        print("\(Date())-\(className ?? ""):\(functionName)-\(message)\n")
    #endif
}
