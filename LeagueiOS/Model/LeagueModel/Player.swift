//
//  Player.swift
//  LeagueiOS
//
//  Created by Dennis on 07.06.18.
//  Copyright © 2018 Dennis Hübner. All rights reserved.
//

import Foundation

class Player {
    var identifier: String
    var name: String
    var place: NSNumber
    var pace: NSNumber
    var pins: NSNumber
    var points: NSNumber
    var hdcp: NSNumber
    var teamName: String?
    
    init(withIdentifier: String) {
        self.identifier = withIdentifier
        self.name = ""
        self.place = 0
        self.pace = 0
        self.pins = 0
        self.points = 0
        self.hdcp = 0
    }
}
