//
//  TweetViewController.swift
//  TwitterDemo
//
//  Created by Yerneni, Naresh on 4/14/17.
//  Copyright © 2017 Yerneni, Naresh. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController{

   
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    var profile: User?
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        navigationController?.navigationBar.barTintColor = UIColor(red:0.11, green:0.63, blue:0.95, alpha:1.00)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = .white

        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            for tweet in tweets {
                print(tweet.text!)
            }
            
            
            self.refreshControl = UIRefreshControl()
            self.refreshControl.addTarget(self, action: #selector(TweetViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
            
            self.tableView.insertSubview(self.refreshControl, at: 0)
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        })
        
        
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "postTweet"), object: nil, queue: OperationQueue.main, using: {
            (Notification) -> Void in
            let tweetObject = Notification.object as! NSDictionary
            let tweet = Tweet(dictionary: tweetObject)
            self.tweets.insert(tweet, at: 0)
            self.tableView.reloadData()
        })
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue:"favorited"), object: nil, queue: OperationQueue.main, using: {
            (Notification) -> Void in
                      
                let userInfo = Notification.userInfo
                let sender = userInfo?["info"] as? TweetCell
            
            
            if  let tweetID = sender?.tweetData?.tweetID {
                
                let successBlock : (Tweet) -> () = { (receivedTweet)  in
                    sender?.tweetData?.updateWith(tweet: receivedTweet)
                    sender?.updateFavDisplay()
                }
                
                let errorBlock : (Error)->() = { (error) in
                    // @todo: show error banner
                }
                
                if sender?.tweetData?.favorited! == true {
                    TwitterClient.sharedInstance?.post(unfavoriteTweetID: tweetID, success:successBlock, error: errorBlock)
                } else {
                    TwitterClient.sharedInstance?.post(favoriteTweetID: tweetID, success: successBlock, error:errorBlock)
                }
            }
            
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "tweetDetailSegue"{
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let tweet = tweets[(indexPath?.row)!]
        
        let detailViewController = segue.destination as? TweetDetailController
        detailViewController?.tweet = tweet
        }
        
        else if segue.identifier == "ShowUserProfileSegue",
            
            let userProfileVC = segue.destination as? ProfileViewController {
            
            userProfileVC.user = profile
        }

        
//        else{
//            //let cell = sender as? TweetCell,
//            let navController = segue.destination as? UINavigationController 
//            let userProfileVC = navController?.topViewController as? ProfileViewController
//            userProfileVC?.user = profile
//        }

        
    }
    
    @IBAction func onLogout(_ sender: Any) {
         TwitterClient.sharedInstance?.logout()
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            for tweet in tweets {
                print(tweet.text!)
            }
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        })
    }
    
}

extension TweetViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
//        cell.tweetData = tweets?[indexPath.row] ?? nil
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweetData = tweets?[indexPath.row] ?? nil
        cell.profileImage.tag = indexPath.row
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        cell.profileImage.addGestureRecognizer(gestureRecognizer)
        cell.profileImage.isUserInteractionEnabled = true
        cell.profileImage.tag = indexPath.row
        
        return cell
    }
    

    
    func onTap(_ sender: UITapGestureRecognizer) {
        if let tappedRow = sender.view?.tag {
            let tweet = tweets[tappedRow]
         
                if let tappedUser = tweet.user {
                    profile = tappedUser
                }
            
        }
        performSegue(withIdentifier: "ShowUserProfileSegue", sender: self)
//        self.navigationController?.pushViewController(ProfileViewController, animated: true)

        
      
        
    }
}



