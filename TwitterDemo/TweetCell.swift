//
//  TweetCell.swift
//  TwitterDemo
//
//  Created by Yerneni, Naresh on 4/14/17.
//  Copyright © 2017 Yerneni, Naresh. All rights reserved.
//

import UIKit



class TweetCell: UITableViewCell {

   
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
       
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var retweetLabelCount: UILabel!
    
    @IBOutlet weak var favLabelCount: UILabel!
    @IBOutlet weak var favImage: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.layer.cornerRadius = 8
        profileImage.clipsToBounds = true
        
        let favTap = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped))
        self.favImage.isUserInteractionEnabled = true
        self.favImage?.addGestureRecognizer(favTap)

    }
    
    var tweetData: Tweet? {
        didSet{
            let user = tweetData?.user
            
            nameLabel.text = tweetData?.user?.name as String?
            tweetLabel.text = tweetData?.text as String?
            
            if let profileUrl = user?.profileUrl {
                self.profileImage.setImageWith(profileUrl as URL)
            }
            
            if let screenname = user?.screenname {
                userNameLabel.text = String("@\(screenname)")
            }
            timestampLabel.text = tweetData?.timestamp
            
            
            if let likes = tweetData?.favoritesCount {
                favLabelCount.text = String(likes)
            }
            
            if let retweetCount = tweetData?.retweetCount {
                retweetLabelCount.text = String(retweetCount)
            }
          updateFavDisplay()
        }
    }
    
    func updateFavDisplay()
    {
        
        if let likes = tweetData?.favoritesCount {
            favLabelCount.text = String(likes)
                   }

        var newImage : UIImage!
        if let favorited = tweetData?.favorited {
        
            if(favorited == true) {
            newImage = UIImage(named:"heartRed" )
            
          }
           else {
            newImage = UIImage(named:"heartGray" )
            
           }
        }
      
        UIView.transition(with: favImage,
                          duration: 0.1,
                          options: UIViewAnimationOptions.transitionCrossDissolve,
                          animations: {
                            self.favImage.image = newImage
        }, completion: nil)
        
        
//        self.setNeedsDisplay()
    }
    
    func favoriteTapped() {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "favorited"), object: self,userInfo:["info":self])
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
