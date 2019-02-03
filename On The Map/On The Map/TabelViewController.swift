//
//  TabelViewController.swift
//  On The Map
//
//  Created by Hend Alkabani on 29/01/2019.
//  Copyright © 2019 Hend Alkabani. All rights reserved.
//

import UIKit
import SafariServices
class TabelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var studentLocations = [StudentsLocations]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        studentLocations = Locations.studentsInfo
        self.tableView.reloadData()
    }
    
    @IBAction func refresh(_ sender: Any) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Locations.studentsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as! mapTableViewCell
        let fName = Locations.studentsInfo[(indexPath as NSIndexPath).row].firstName
        let lName = Locations.studentsInfo[(indexPath as NSIndexPath).row].lastName
        cell.updateCell(fName ?? "" , lName ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let url = URL(string: Locations.studentsInfo[(indexPath as NSIndexPath).row].mediaURL)!
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func logOut(_ sender: Any) {
        NetworkConnection.logout { (errorMessage) in
            if errorMessage == nil{
                AppDelegate.user.clearUser()
                DispatchQueue.main.async {
                    let TabViewController = self.storyboard?.instantiateViewController(withIdentifier: "logout")
                    UIApplication.shared.keyWindow?.rootViewController = TabViewController                }
            }
            else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: errorMessage!)
                }
            }
        }
    }
    
}
