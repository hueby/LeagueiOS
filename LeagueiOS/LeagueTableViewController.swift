//
//  LeagueTableViewController.swift
//  LeagueiOS
//
//  Created by Dennis on 06.06.18.
//  Copyright © 2018 Dennis Hübner. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LeagueTableViewController: UITableViewController, LeagueDelegate {
    
    var leagueIdentifier: String = ""
    var league: League?

    func leagueUpdated(league: League) {
        self.league! = league
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.league = League(withLeagueIdentifier: leagueIdentifier, name: "")
        self.league!.leagueDelegate = self
        
//        let ref = Database.database().reference()
//        let teams = ref.child("events").child("league").child(self.leagueIdentifier).child("teams")
//        teams.observe(DataEventType.value, with: { (snapshot) in
//            self.teamList = [String]()
//            let rawTeams = snapshot.value as? NSArray
//            for teams in rawTeams! {
//                let obj: NSDictionary = teams as! NSDictionary
//                self.teamList.append(obj.value(forKey: "name") as! String)
//
//            }
//            self.tableView.reloadData();
//        })
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.league!.leagueTeams.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> TeamCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as! TeamCell

        let team = self.league!.leagueTeams[indexPath.row]
        cell.teamLabel.text = team.name
        if self.league!.currentPlayer?.teamName == team.name {
            cell.teamLabel.font = UIFont.boldSystemFont(ofSize: cell.teamLabel.font.pointSize)
        }
        
        return cell
    }
}

class TeamCell : UITableViewCell {
    @IBOutlet weak var teamLabel: UILabel!
}
