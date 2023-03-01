//
//  NavViewModel.swift
//  FavoriteTeams
//
//  Created by Pattison, Brian (Cognizant) on 2/27/23.
//

import Foundation


@MainActor class NavVM: ObservableObject {
    
    
    enum currentScreen {
        case selectingTeams, viewingTeams
    }
    
    @Published var currentScreen : currentScreen = .viewingTeams
    
    @Published var notificationsAllowed: Bool = false
}
