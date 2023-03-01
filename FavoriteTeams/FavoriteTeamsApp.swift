//
//  FavoriteTeamsApp.swift
//  FavoriteTeams
//
//  Created by Pattison, Brian (Cognizant) on 2/27/23.
//

import SwiftUI

@main
struct FavoriteTeamsApp: App {
    
    @StateObject var navVM = NavVM()
    
    var teamSelectionVM = TeamSelectionVM()
    
    init() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { result, error in
            if let error = error {
                print(error)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navVM)
                .environmentObject(teamSelectionVM)
        }
    }
    
}
