//
//  TweetDetailController.swift
//  TwitterDemo
//
//  Created by Yerneni, Naresh on 4/15/17.
//  Copyright © 2017 Yerneni, Naresh. All rights reserved.
//

import UIKit

class TweetDetailController: UIViewController {

    var tweet: Tweet?

    
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var twitNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tweet = tweet {
            if let user = tweet.user {
                
                if let imageURL = user.profileUrl {
                    profileImage.setImageWith(imageURL as URL)
                }
                
              
                if let  favs = user.favoritesCount{
                    favoritesCountLabel.text = String(favs)
                }
                
                nameLabel.text = user.name as String?
                twitNameLabel.text="@\(user.screenname!)"

            }
            
         
            tweetText.text = tweet.text as String?
            
            retweetCountLabel.text = String(tweet.retweetCount) 
       
            
        
             }
           }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
