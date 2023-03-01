//
//  TeamSelection.swift
//  FavoriteTeams
//
//  Created by Pattison, Brian (Cognizant) on 2/27/23.
//

import Foundation
import SwiftUI

struct TeamSelection: View {
    
    @EnvironmentObject var navVM: NavVM
    
    @EnvironmentObject var teamSelectionVM: TeamSelectionVM
    
    @State var league: String = ""
    
    @State var teams: [Team] = []
    
    @State var selectedTeams: [Team] = []
    
    @State var searchText: String = ""
    
    var body: some View {
        List {
            Button {
                self.searchText = ""
                if teamSelectionVM.currentLeague != "NFL" {
                    teamSelectionVM.nextLeague()
                }
                else {
                    teamSelectionVM.selectedTeams.removeAll()
                    teamSelectionVM.selectedTeams.append(contentsOf: selectedTeams)
                    UserDefaults.standard.save(customObject: selectedTeams, inKey: "teams")
                    navVM.currentScreen = .viewingTeams
                    teamSelectionVM.firstLeague()
                }
                if teamSelectionVM.currentLeague == "NHL" {
                    teams = teamSelectionVM.NHLTeams
                }
                else if teamSelectionVM.currentLeague == "NFL" {
                    teams = teamSelectionVM.NFLTeams
                }
                else if teamSelectionVM.currentLeague == "MLB" {
                    teams = teamSelectionVM.MLBTeams
                }
                else if teamSelectionVM.currentLeague == "NBA" {
                    teams = teamSelectionVM.NBATeams
                }
            } label: {
                Text("Next")
                    .foregroundStyle(.blue)
            }
            .buttonStyle(PlainButtonStyle())
            ForEach(searchResults) { team in
                TeamRow(team: team, teams: $selectedTeams)
            }
            Button {
                self.searchText = ""
                if teamSelectionVM.currentLeague != "NFL" {
                    teamSelectionVM.nextLeague()
                }
                else {
                    teamSelectionVM.selectedTeams.removeAll()
                    teamSelectionVM.selectedTeams.append(contentsOf: selectedTeams)
                    UserDefaults.standard.save(customObject: selectedTeams, inKey: "teams")
                    navVM.currentScreen = .viewingTeams
                    teamSelectionVM.firstLeague()
                }
                if teamSelectionVM.currentLeague == "NHL" {
                    teams = teamSelectionVM.NHLTeams
                }
                else if teamSelectionVM.currentLeague == "NFL" {
                    teams = teamSelectionVM.NFLTeams
                }
                else if teamSelectionVM.currentLeague == "MLB" {
                    teams = teamSelectionVM.MLBTeams
                }
                else if teamSelectionVM.currentLeague == "NBA" {
                    teams = teamSelectionVM.NBATeams
                }
            } label: {
                Text("Next")
                    .foregroundStyle(.blue)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .searchable(text: $searchText, prompt: "Find your team")
        .navigationTitle(teamSelectionVM.currentLeague)
        .onAppear {
            teamSelectionVM.firstLeague()
            league = teamSelectionVM.currentLeague
            teams = teamSelectionVM.NBATeams
        }
    }
    
    var searchResults: [Team] {
        if searchText.isEmpty {
            return teams
        } else {
            return teams.filter { $0.fullName.contains(searchText) }
        }
    }
}

