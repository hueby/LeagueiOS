//
//  DashboardViewController.swift
//  LeagueiOS
//
//  Created by Dennis on 06.06.18.
//  Copyright © 2018 Dennis Hübner. All rights reserved.
//

import UIKit
import FirebaseAuth

class DashboardViewController: UIViewController {
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(Auth.auth().currentUser == nil) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "loginViewController")
            self.present(loginVC, animated: true, completion: nil)
        } else {
            print("Logged in: \(String(describing: Auth.auth().currentUser))")
            self.userLabel.text = Auth.auth().currentUser?.uid
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutDidTouch(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.viewDidAppear(true);
        } catch let error as NSError {
            print ("Error signing out: %@", error)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
