//
//  File.swift
//  FavoriteTeams
//
//  Created by Pattison, Brian (Cognizant) on 2/27/23.
//

import Foundation

extension Date {
    
    func monthName() -> String {
            let df = DateFormatter()
            df.setLocalizedDateFormatFromTemplate("MMM")
            return(df.string(from: self))
    }
    
    func monthNumber() -> Int {
            let df = DateFormatter()
            df.setLocalizedDateFormatFromTemplate("MMM")
            let monthName = df.string(from: self)
        switch monthName {
        case "Jan" :
            return 0
        case "Feb" :
            return 1
        case "Mar" :
            return 2
        case "Apr" :
            return 3
        case "May" :
            return 4
        case "Jun" :
            return 5
        case "Jul" :
            return 6
        case "Aug" :
            return 7
        case "Sep" :
            return 8
        case "Oct" :
            return 9
        case "Nov" :
            return 10
        case "Dec" :
            return 11
        default:
            return 0
        }
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
