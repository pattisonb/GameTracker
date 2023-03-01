//
//  Game.swift
//  FavoriteTeams
//
//  Created by Pattison, Brian (Cognizant) on 2/27/23.
//
import Foundation

struct Game: Identifiable {
    var id = UUID()
    var date: String
    var yourTeam: String
    var playingTeam: String
    var home: Bool
    
    func convertDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.dateFormat = "YYYY MMM d HH:mm a"
        var formattedDate = dateFormatter.date(from: "2023 \(self.date)")
        return formattedDate!
    }
    
    func formatDate() -> String {
        let dateParts = date.components(separatedBy: " ")
        return "\(dateParts[0]) \(dateParts[1]) @ \(dateParts[2]) \(dateParts[3])"
    }
    
    func getMonthAndDay() -> String {
        let dateParts = date.components(separatedBy: " ")
        return "\(dateParts[0]) \(dateParts[1])"
    }
    
    func getTime() -> String {
        let dateParts = date.components(separatedBy: " ")
        return "\(dateParts[2]) \(dateParts[3])"
    }
    
}

extension Game {
    static func placeholder( _ id: UUID) -> Game {
        Game(id: id, date: "Feb 27 7:30 PM", yourTeam: "Boston Celtics", playingTeam: "New York Knicks", home: false)
    }
}
