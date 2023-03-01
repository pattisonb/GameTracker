//
//  TeamSelectionVM.swift
//  FavoriteTeams
//
//  Created by Pattison, Brian (Cognizant) on 2/27/23.
//

import Foundation
import SwiftSoup


class TeamSelectionVM: ObservableObject {
    
    @Published var currentLeague = leagues[0]
    
    let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    let defaults = UserDefaults.standard
    
    var index = 0
    
    func nextLeague() {
        index += 1
        if index == leagues.count {
            index = 0
        }
        currentLeague = leagues[index]
    }
    
    func firstLeague() {
        currentLeague = leagues[0]
    }
    
    @Published var NBATeams: [Team] = load("nbaData.json")
    
    @Published var NHLTeams: [Team] = load("nhlData.json")
    
    @Published var NFLTeams: [Team] = load("nflData.json")
    
    @Published var MLBTeams: [Team] = load("mlbData.json")
    
    @Published var selectedTeams: [Team] = []
    
    @Published var todayGames: [Game] = []
    
    @Published var upcomingGames: [Game] = []
    
    @Published var allGames: [Game] = []
    
    func populateGames() {
        todayGames.removeAll()
        upcomingGames.removeAll()
        allGames.removeAll()
        if let teams = defaults.retrieve(object: [Team].self, fromKey: "teams") {
            for team in teams {
                if Date().monthNumber() < 7 && team.league.lowercased() != "nfl" {
                    var data = getGameData(teamName: "\(team.city) \(team.name)", league: team.league.lowercased(), abbreviation: team.dataAbb, monthNumber: Date().monthNumber())
                    if Date().get(.day) >= 27 {
                        data.append(contentsOf: getGameData(teamName: "\(team.city) \(team.name)", league: team.league.lowercased(), abbreviation: team.dataAbb, monthNumber: Date().monthNumber() + 1))
                    }
                    var extraGames = 0
                    for game in data {
                        let currentDate = Date()
                        if isSameDay(gameDate: game.getMonthAndDay()) {
                            todayGames.append(game)
                        }
                        else if currentDate.compare(game.convertDate()) == ComparisonResult.orderedAscending {
                            if isCloseDay(date1: currentDate, date2: game.convertDate()) {
                                upcomingGames.append(game)
                            }
                            else {
                                if extraGames < 3 {
                                    allGames.append(game)
                                    extraGames += 1
                                }
                            }
                        }
                    }
                }
                todayGames = todayGames.sorted(by: { $0.convertDate().compare($1.convertDate()) == .orderedAscending })
                upcomingGames = upcomingGames.sorted(by: { $0.convertDate().compare($1.convertDate()) == .orderedAscending })
                allGames = allGames.sorted(by: { $0.convertDate().compare($1.convertDate()) == .orderedAscending })
            }
        }
    }
    
    func getTodayGames() -> [Game] {
        if let teams = defaults.retrieve(object: [Team].self, fromKey: "teams") {
            for team in teams {
                if Date().monthNumber() < 7 && team.league.lowercased() != "nfl" {
                    var data = getGameData(teamName: "\(team.city) \(team.name)", league: team.league.lowercased(), abbreviation: team.dataAbb, monthNumber: Date().monthNumber())
                    var extraGames = 0
                    for game in data {
                        if isSameDay(gameDate: game.getMonthAndDay()) {
                            todayGames.append(game)
                        }
                    }
                }
                todayGames = todayGames.sorted(by: { $0.convertDate().compare($1.convertDate()) == .orderedAscending })
            }
        }
        return todayGames
    }
    
    func getGameData(teamName: String, league: String, abbreviation: String, monthNumber: Int) -> [Game]{
        var allGames: [Game] = []
        let url = URL(string:"https://www.gamedaycalendar.com/schedules/\(league)/\(abbreviation)/2022/\(monthNumber)")!
        let html = try! String(contentsOf: url)
        let doc = try! SwiftSoup.parse(html)
        
        let table = try! doc.getElementsByClass("table").first()?.text()
        
        if table != nil {
            let games = table!.components(separatedBy: ", ")[1...]
            
            
            for game in games {
                let parsedHomeGame = game.components(separatedBy: "vs")
                let parsedAwayGame = game.components(separatedBy: "@")
                if parsedHomeGame.count > 1 {
                    let date = parsedHomeGame[0].dropLast()
                    let team = parsedHomeGame.last
                    var str = team! as String
                    if str.contains(days) {
                        str = String((team?.dropLast(4))!)
                    }
                    str = str.trimmingCharacters(in: .whitespaces)
                    let game = Game(date: String(date), yourTeam: teamName, playingTeam: str, home: true)
                    allGames.append(game)
                }
                else if parsedAwayGame.count > 1 {
                    let date = parsedAwayGame[0].dropLast()
                    let team = parsedAwayGame.last
                    var str = team! as String
                    if str.contains(days) {
                        str = String((team?.dropLast(4))!)
                    }
                    str = str.trimmingCharacters(in: .whitespaces)
                    let game = Game(date: String(date), yourTeam: teamName, playingTeam: str, home: false)
                    allGames.append(game)
                }
            }
            return(allGames)
        }
        return []
    }
    
    func isSameDay(gameDate: String) -> Bool {
        var currentDate = Date().monthName()
        currentDate += " "
        currentDate += String(Date().get(.day))
        if gameDate == currentDate {
            return true
        }
        return false
    }
    
    func isCloseDay(date1: Date, date2: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: date1, to: date2)
        if diff.day! <= 2 {
            return true
        } else {
            return false
        }
    }
    
}

var leagues: [String] = ["NBA", "NHL", "MLB", "NFL"]

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

