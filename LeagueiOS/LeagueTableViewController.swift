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

class LeagueTableViewController: UITableViewController {

    var leagueList = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ref = Database.database().reference()
        let league = ref.child("events").child("league")
        league.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            for val in value!.allKeys {
                let leag = val as? String
                let _leag = value!.object(forKey: leag!) as! NSDictionary
                let players = _leag["players"] as! NSDictionary
                let keys = players.allKeys as NSArray
                if keys.contains(Auth.auth().currentUser!.uid) {
                    self.leagueList.append(_leag)
                }
            }
            self.tableView.reloadData();
        })
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.leagueList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leagueCell", for: indexPath)

        let league = self.leagueList[indexPath.row]
        cell.textLabel?.text = league.object(forKey: "name") as? String
        
        return cell
    }
}
