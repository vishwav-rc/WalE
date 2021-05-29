//
//  AppError.swift
//  NASA APOD
//
//  Created by Vishwanath Vallamkondi on 29/05/21.
//

import Foundation

enum AppError : Error {
    case notFound
    case parseError
}

extension AppError : CustomStringConvertible {
    var description: String {
        switch self {
        case .notFound:
            return "Unable to get data"
        case .parseError:
            return "Unable to parse the response data"
        }
    }
}
