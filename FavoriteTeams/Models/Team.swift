//
//  Team.swift
//  FavoriteTeams
//
//  Created by Pattison, Brian (Cognizant) on 2/27/23.
//

import Foundation

struct Team: Codable, Hashable, Identifiable {
    
    var id: Int
    var league: String
    var city: String
    var name: String
    var fullName: String
    var conference: String
    var division: String
    var pictureAbb: String
    var dataAbb: String
    
    func imageURL() -> String {
        return "https://a.espncdn.com/combiner/i?img=/i/teamlogos/\(league.lowercased())/500/\(pictureAbb).png&amp;h=90&amp;w=90"
    }
}

