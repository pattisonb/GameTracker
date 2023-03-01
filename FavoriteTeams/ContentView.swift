//
//  ContentView.swift
//  FavoriteTeams
//
//  Created by Pattison, Brian (Cognizant) on 2/27/23.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    let defaults = UserDefaults.standard
    
    @EnvironmentObject var teamSelectionVM: TeamSelectionVM
    @EnvironmentObject var navVM: NavVM
    
    let teams = UserDefaults.standard.retrieve(object: [Team].self, fromKey: "teams")
    
    
    var body: some View {
        ZStack {
            switch navVM.currentScreen {
            case .selectingTeams:
                TeamSelection()
            case .viewingTeams:
                YourTeams()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
