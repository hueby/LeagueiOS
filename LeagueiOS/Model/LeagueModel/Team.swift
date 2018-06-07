//
//  Team.swift
//  LeagueiOS
//
//  Created by Dennis on 07.06.18.
//  Copyright © 2018 Dennis Hübner. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Team {
    var name: String
    var place: NSNumber
    var players: [Player]
    
    init(withName: String) {
        self.name = withName
        self.place = 0
        self.players = [Player]()
    }
}
