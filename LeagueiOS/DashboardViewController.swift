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
    
    var eventList = [[String: [NSDictionary]]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference()
        let league = ref.child("events")
        league.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            for event in value!.allKeys {
                var data = [NSDictionary]()
            
                let events = value![event] as? NSDictionary
                for evs in events!.allKeys {
                    let players = events!.value(forKeyPath: "\(evs).players") as! NSDictionary
                    let playerArray: NSArray = players.allKeys as NSArray
                    if(playerArray.contains(Auth.auth().currentUser!.uid)){
                        data.append([evs: events!.value(forKeyPath: "\(evs).name") as! String])
                    }
                }
                if(data.count != 0) {
                    let ev = [event as! String: data]
                    self.eventList.append(ev)
                }
            }
            
            self.tableView.reloadData()
        })
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
        let event = self.eventList[section] as NSDictionary
        switch event.allKeys.first as! String {
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
        
        let event = self.eventList[indexPath.section] as NSDictionary
        let path = event.allKeys.first as! String
        let detailArray: NSArray = event.object(forKey: path) as! NSArray
        let detailDict: NSDictionary = detailArray[0] as! NSDictionary
        let detail = detailDict.allValues[indexPath.row] as! String
        cell.eventLabel.text = detail
        cell.identifier = event.allKeys.first as! String
        cell.type = path
        
        print(cell.type)
        
        return cell
    }
}

class EventTableViewCell : UITableViewCell {
    @IBOutlet weak var eventLabel: UILabel!
    var identifier: String = ""
    var type: String = ""
}
