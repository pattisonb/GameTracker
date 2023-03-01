//
//  YourTeams.swift
//  FavoriteTeams
//
//  Created by Pattison, Brian (Cognizant) on 2/27/23.
//

import SwiftUI

struct YourTeams: View {
    
    @EnvironmentObject var teamSelectionVM: TeamSelectionVM
    
    @EnvironmentObject var navVM: NavVM
    
    var body: some View {
        NavigationView {
            List {
                if teamSelectionVM.todayGames.isEmpty {
                    Section {
                        Text("No games today")
                            .frame(alignment: .center)
                            .foregroundColor(.gray)
                    }
                }
                else {
                    Section {
                        ForEach(teamSelectionVM.todayGames) { game in
                            GameRow(game: game)
                        }
                    } header: {
                        Text("Today's Games")
                    }
                }
                Section {
                    ForEach(teamSelectionVM.upcomingGames) { game in
                        GameRow(game: game)
                    }
                } header: {
                    Text("Upcoming Games")
                }
                Section {
                    ForEach(teamSelectionVM.allGames) { game in
                        GameRow(game: game)
                    }
                } header: {
                    Text("More Games")
                }
            }
            .toolbar {
                ToolbarItem (placement: .navigationBarLeading) {
                    Button {
                        navVM.currentScreen = .selectingTeams
                    } label: {
                        Text("Reselect Teams")
                    }
                }
            }
            .refreshable {
                teamSelectionVM.populateGames()
            }
        }
        .onAppear {
            teamSelectionVM.populateGames()
            let current = UNUserNotificationCenter.current()

            current.getNotificationSettings(completionHandler: { (settings) in
                if settings.authorizationStatus == .authorized {
                    let content = UNMutableNotificationContent()
                    if teamSelectionVM.todayGames.count == 1 {
                        content.title = "1 Game Today"
                    }
                    else {
                        content.title = "\(teamSelectionVM.todayGames.count) Games Today"
                    }
                    if teamSelectionVM.todayGames.count == 1 {
                        content.subtitle = "\(teamSelectionVM.todayGames[0].yourTeam) vs. \(teamSelectionVM.todayGames[0].playingTeam) @ \(teamSelectionVM.todayGames[0].getTime())"
                    }
                    else if teamSelectionVM.todayGames.count > 1 {
                        for game in teamSelectionVM.todayGames.dropLast() {
                            content.subtitle += "\(game.yourTeam) vs. \(game.playingTeam) @ \(game.getTime())\n"
                        }
                        content.subtitle += "\(teamSelectionVM.todayGames[teamSelectionVM.todayGames.count - 1].yourTeam) vs. \(teamSelectionVM.todayGames[teamSelectionVM.todayGames.count - 1].playingTeam) @ \(teamSelectionVM.todayGames[teamSelectionVM.todayGames.count - 1].getTime())\n"
                    }
                    content.sound = UNNotificationSound.default
                    
                    var datComp = DateComponents()
                    datComp.hour = 8
                    datComp.minute = 0
                    let trigger = UNCalendarNotificationTrigger(dateMatching: datComp, repeats: true)
                    let request = UNNotificationRequest(identifier: "ID", content: content, trigger: trigger)
                                    UNUserNotificationCenter.current().add(request) { (error : Error?) in
                                        if let theError = error {
                                            print(theError.localizedDescription)
                                        }
                                    }

                    UNUserNotificationCenter.current().add(request)
                }
            })
        }
    }
}
