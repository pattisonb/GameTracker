//
//  TeamRow.swift
//  FavoriteTeams
//
//  Created by Pattison, Brian (Cognizant) on 2/27/23.
//

import SwiftUI
import CachedAsyncImage

struct TeamRow: View {
    
    var team: Team
    
    @State var isSet: Bool = false
    
    @Binding var teams: [Team]
    
    var body: some View {
        VStack{
            HStack {
                Text("\(team.fullName)")
                Spacer()
                Button {
                    if isSet {
                        teams = teams.filter{ $0.id != team.id }
                    }
                    else {
                        teams.append(team)
                    }
                    isSet.toggle()
                } label: {
                    Label("Add Team", systemImage: isSet ? "checkmark.circle.fill" : "checkmark.circle")
                        .labelStyle(.iconOnly)
                        .foregroundColor(isSet ? .blue : .gray)

                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding([.bottom, .top])
        }
    }
}
