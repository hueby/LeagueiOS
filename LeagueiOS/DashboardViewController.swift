//
//  DashboardViewController.swift
//  LeagueiOS
//
//  Created by Dennis on 06.06.18.
//  Copyright © 2018 Dennis Hübner. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DashboardViewController: UITableViewController {
    
    struct EventDetail {
        let name: String
        let identifier: String
    }
    
    struct Events {
        let type: String
        let ev: [EventDetail]
    }
    
    var eventList: [[Events]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference()
        let league = ref.child("events")
        league.observe(DataEventType.value) { (snapshot) in
            self.eventList = []
            let events = snapshot.value as? [String: NSDictionary]
            
            for (key, value) in events! {
                // event = league OR event = tournament
                var data: [EventDetail] = []
                switch key {
                case "league":
                    self.searchLeague(value: value, data: &data);
                    break;
                case "tournament":
                    self.searchTournament(value: value, data: &data);
                    break;
                default:
                    break;
                }
                

                if(data.count != 0) {
                    let ev = Events(type: key, ev: data)
                    self.eventList.append([ev])
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    func searchLeague(value: NSDictionary, data: inout [EventDetail]) {
        for (lKey, _) in value {
            let leag = value[lKey] as! NSDictionary
            let teams = leag["teams"] as! NSArray
            for t in teams {
                let team = t as! NSDictionary
                let players = team["players"] as! NSArray
                if(players.contains(Auth.auth().currentUser!.uid)){
                    let eD = EventDetail(name: leag["name"] as! String, identifier: lKey as! String)
                    data.append(eD)
                }
            }
        }
    }
    
    func searchTournament(value: NSDictionary, data: inout [EventDetail]) {
        for (lKey, _) in value {
            let tour = value[lKey] as! NSDictionary
            let players = tour["players"] as! NSDictionary
            if (players.allKeys as NSArray).contains(Auth.auth().currentUser!.uid) {
                let eD = EventDetail(name: tour["name"] as! String, identifier: lKey as! String)
                data.append(eD)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(Auth.auth().currentUser == nil) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "loginViewController")
            self.present(loginVC, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutDidTouch(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.viewDidAppear(true)
        } catch let error as NSError {
            print ("Error signing out: %@", error)
        }
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventList[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.eventList.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let event = self.eventList[section].first

        switch event?.type {
        case "league":
            return "Liga"
        case "tournament":
            return "Turnier"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> EventTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboardCell", for: indexPath) as! EventTableViewCell
        
        let events = self.eventList[indexPath.section].first

        cell.type = events!.type
        cell.eventLabel.text = events!.ev[indexPath.row].name
        cell.identifier = events!.ev[indexPath.row].identifier
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! EventTableViewCell
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        switch(cell.type) {
        case "league":
            let lVC = storyboard.instantiateViewController(withIdentifier: "leagueDashboard") as! LeagueDashboardTableViewController
            lVC.leagueIdentifier = cell.identifier
            lVC.title = cell.eventLabel.text
            self.navigationController?.pushViewController(lVC, animated: true)
            break;
        case "tournament":
            break;
        default:
            break
        }
    }
}

class EventTableViewCell : UITableViewCell {
    @IBOutlet weak var eventLabel: UILabel!
    var identifier: String = ""
    var type: String = ""
}
