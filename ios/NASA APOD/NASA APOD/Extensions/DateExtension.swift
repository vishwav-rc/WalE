//
//  DateExtension.swift
//  NASA APOD
//
//  Created by Vishwanath Vallamkondi on 29/05/21.
//

import Foundation

extension Date {
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
}
