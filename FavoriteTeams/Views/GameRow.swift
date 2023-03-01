//
//  GameRow.swift
//  FavoriteTeams
//
//  Created by Pattison, Brian (Cognizant) on 2/27/23.
//

import SwiftUI
import CachedAsyncImage

struct GameRow: View {
    
    @EnvironmentObject var teamSelectionVM: TeamSelectionVM
    
    var game: Game
    
    var body: some View {
        HStack {
            VStack (alignment: .center) {
                HStack {
//                    CachedAsyncImage(
//                        url: URL(string: game.yourTeam.imageURL())) { image in
//                            image.resizable()
//                                .frame(width: 45, height: 45)
//                        } placeholder: {
//                            ProgressView()
//                        }
                    Spacer()
                    Text(game.yourTeam)
                    Text(game.home ? "vs." : "@")
                    Text(game.playingTeam)
                    Spacer()
//                    CachedAsyncImage(
//                        url: URL(string: game.playingTeam.imageURL())) { image in
//                            image.resizable()
//                                .frame(width: 45, height: 45)
//                        } placeholder: {
//                            ProgressView()
//                        }
                }
                Text(game.formatDate())
            }
            .font(.system(size: 13))
        }
    }
}
