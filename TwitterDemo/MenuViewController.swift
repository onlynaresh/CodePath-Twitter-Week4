//
//  MenuviewController.swift
//  TwitterDemo
//
//  Created by Yerneni, Naresh on 4/23/17.
//  Copyright © 2017 Yerneni, Naresh. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var tweetsViewController: UIViewController!
    private var mentionsViewController: UIViewController!
    private var profileViewController: UIViewController!
    
    let titles = ["Profile", "Timeline", "Mentions","Accounts","Logout"]
    var viewControllers: [UIViewController] = []
    
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
       tweetsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
       profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
       mentionsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        
        viewControllers.append(profileViewController)
        viewControllers.append(tweetsViewController)
        viewControllers.append(mentionsViewController)
        
        hamburgerViewController.contentViewController = tweetsViewController
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        cell.menuTitleLabel.text = titles[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 4)
        {
            TwitterClient.sharedInstance?.logout()
        }
    else {
        tableView.deselectRow(at: indexPath, animated: true)
        
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        }
    }
    
    

    
}
