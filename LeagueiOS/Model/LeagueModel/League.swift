//
//  League.swift
//  LeagueiOS
//
//  Created by Dennis on 07.06.18.
//  Copyright © 2018 Dennis Hübner. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class League {
    var leagueName: String
    var leagueIdentifier: String
    var leagueTeams: [Team]
    var currentPlayer: Player?
    weak var leagueDelegate: LeagueDelegate?
    
    init(withLeagueIdentifier: String, name: String) {
        self.leagueIdentifier = withLeagueIdentifier
        self.leagueName = name
        self.leagueTeams = [Team]()
        self.setupLeague()
    }
    
    func setupLeague() {
        let ref = Database.database().reference()
        let leagueRef = ref.child("events").child("league").child(self.leagueIdentifier)
        leagueRef.observe(DataEventType.value) { (snapshot) in
            self.leagueTeams = [Team]()
            let league = snapshot.value as? [String: AnyObject] ?? [:]
            // first fill all teams and players
            let teams = league["teams"] as! NSArray;
            for t in teams {
                let te = t as! NSDictionary
                let team = Team(withName: te["name"] as! String)
                let p = te["players"] as! NSArray
                
                for player in p {
                    if(player as? String == nil) {
                        continue
                    }
                    let pl = Player(withIdentifier: (player as! String))
                    pl.teamName = team.name
                    team.players.append(pl)
                    if(player as! String == Auth.auth().currentUser!.uid) {
                        self.currentPlayer = pl
                    }
                }
                self.leagueTeams.append(team)
            }
            self.leagueDelegate?.leagueUpdated(league: self)
        }
    }
}

protocol LeagueDelegate: class {
    func leagueUpdated(league: League)
}
