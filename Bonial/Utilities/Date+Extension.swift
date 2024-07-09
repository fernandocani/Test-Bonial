//
//  Date+Extension.swift
//  Bonial
//
//  Created by Fernando Cani on 08/07/2024.
//

import Foundation

extension Date {
    
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: now)
        if let year = components.year, year > 0 {
            return self.formattedDate()
        }
        if let month = components.month, month > 0 {
            return self.formattedDate()
        }
        if let day = components.day, day > 0 {
            if day >= 1 {
                return self.formattedDate()
            }
        }
        if let hour = components.hour, hour > 0 {
            return hour == 1 ? "\(hour) hour ago" : "\(hour) hours ago"
        }
        if let minute = components.minute, minute > 0 {
            return minute == 1 ? "\(minute) minute ago" : "\(minute) minutes ago"
        }
        return "just now"
    }
    
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let day = Calendar.current.component(.day, from: self)
        var daySuffix = "th"
        if day == 1 || day == 21 || day == 31 {
            daySuffix = "st"
        } else if day == 2 || day == 22 {
            daySuffix = "nd"
        } else if day == 3 || day == 23 {
            daySuffix = "rd"
        }
        return formatter.string(from: self) + daySuffix
    }
    
}
