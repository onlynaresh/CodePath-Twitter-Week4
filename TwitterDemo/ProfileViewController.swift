//
//  ProfileViewController.swift
//  TwitterDemo
//
//  Created by Yerneni, Naresh on 4/23/17.
//  Copyright © 2017 Yerneni, Naresh. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIGestureRecognizerDelegate {
  
    var tweets: [Tweet]!
    var profile: User?

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var maskView: UIView!
    
    // top level view constraints
    @IBOutlet weak var topLevelViewToTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var topLevelViewTrailingSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var topLevelViewLeadingSpaceConstraint: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var topLevelView: UIView!
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var whiteViewAroundProfileImageView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var numberTweetsLabel: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var numberFollowingLabel: UILabel!
    
    @IBOutlet weak var numberFollowersLabel: UILabel!
    
    
    @IBOutlet weak var headerViewBottomHalf: UIView!
    @IBOutlet weak var headerView: UIView!
    
    
    var user : User?
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
    
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        // set profile image and backdrop image
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        whiteViewAroundProfileImageView.layer.cornerRadius = 5
        whiteViewAroundProfileImageView.clipsToBounds = true
        
        updateProfileHeader()
        
        loadTable()
      
    }
    
    func updateProfileHeader() {
        var localUser: User!
        
        if user != nil {
            localUser=user
        }else {
            localUser = User.currentUser
        }
        
        self.profileImageView.setImageWith(localUser.profileUrl as! URL)
        
        userName.text = localUser.name as String?
        screenName.text = "@\(localUser.screenname!)"
            
        numberFollowersLabel.text = "\(localUser.followersCount ?? 0)"
        numberFollowingLabel.text = "\(localUser.friendsCount ?? 0)"
        numberTweetsLabel.text = "\(localUser.tweetsCount ?? 0)"

    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        super.viewWillAppear(animated)
    }

    
    
      func loadTable() {
        var localUser: User?
        
        if user != nil {
            localUser=user
        }else {
            localUser = User.currentUser
        }
        
            TwitterClient.sharedInstance?.fetchTweets(user : localUser!, success: { (tweets) in
               
                self.tweets = tweets
              //  self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }, error: { (receivedError) in
                print(receivedError)
            })
        }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        print("back button tapped")
        dismiss(animated: false, completion: nil)
    }
    
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweetData = tweets?[indexPath.row] ?? nil
        cell.profileImage.tag = indexPath.row
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
//        cell.profileImage.addGestureRecognizer(gestureRecognizer)
//        cell.profileImage.isUserInteractionEnabled = true
//        cell.profileImage.tag = indexPath.row
        
        return cell
    }
    
    
    
   }


