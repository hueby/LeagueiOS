//
//  LeagueDashboardTableViewController.swift
//  LeagueiOS
//
//  Created by Dennis on 07.06.18.
//  Copyright © 2018 Dennis Hübner. All rights reserved.
//

import UIKit

class LeagueDashboardTableViewController: UITableViewController, LeagueDelegate {
    
    func leagueUpdated(league: League) {
        self.league = league
        
        // first mock data
        playerLeagueInformation[Constants.teamPlace] = 0 as NSNumber
        playerLeagueInformation[Constants.playerPlace] = 0 as NSNumber
        playerLeagueInformation[Constants.playerPace] = 0 as NSNumber
        playerLeagueInformation[Constants.playerPoints] = 0 as NSNumber
        playerLeagueInformation[Constants.playerHdcp] = 0 as NSNumber
        playerLeagueInformation[Constants.playerTeam] = self.league?.currentPlayer?.teamName as AnyObject

        
        self.tableView.reloadData()
    }
    
    
    struct Constants {
        static let teamPlace = "teamPlace"
        static let playerPlace = "playerPlace"
        static let playerPace = "playerPace"
        static let playerPoints = "playerPoints"
        static let playerHdcp = "playerHdcp"
        static let playerTeam = "playerTeam"

    }
    
    var leagueIdentifier: String = ""
    var playerLeagueInformation = [String: AnyObject]()
    var league: League?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.league = League(withLeagueIdentifier: self.leagueIdentifier, name: "")
        self.league?.leagueDelegate = self
        
        let leagueDetail: UIBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .bookmarks,
                            target: self,
                            action: #selector(leagueDetailDidTouch(_:)))
        self.navigationItem.setRightBarButton(leagueDetail, animated: false)
        
        // first mock data
        playerLeagueInformation[Constants.teamPlace] = 0 as NSNumber
        playerLeagueInformation[Constants.playerPlace] = 0 as NSNumber
        playerLeagueInformation[Constants.playerPace] = 0 as NSNumber
        playerLeagueInformation[Constants.playerPoints] = 0 as NSNumber
        playerLeagueInformation[Constants.playerHdcp] = 0 as NSNumber
        playerLeagueInformation[Constants.playerTeam] = self.league?.currentPlayer?.teamName as AnyObject


    }

    @objc func leagueDetailDidTouch(_ sender: UIBarButtonItem!) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let lVC =
            storyboard.instantiateViewController(
                withIdentifier: "leagueViewController")
                as! LeagueTableViewController
        lVC.leagueIdentifier = self.leagueIdentifier
        lVC.title = "Tabelle"
        self.navigationController?.pushViewController(lVC, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.playerLeagueInformation.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! LeagueInformationCell
        
        cell.informationLabel.text = self.playerLeagueInformation.map({ (key: String, value: AnyObject) -> String in
            return "\(key): \(value)"
        })[indexPath.row]
        
        return cell
    }

}

class LeagueInformationCell : UITableViewCell {
    @IBOutlet weak var informationLabel: UILabel!
}
