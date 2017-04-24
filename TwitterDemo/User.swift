//
//  User.swift
//  TwitterDemo
//
//  Created by Yerneni, Naresh on 4/14/17.
//  Copyright © 2017 Yerneni, Naresh. All rights reserved.
//

import UIKit
import Foundation

class User: NSObject {
    
    var name: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    var dictionary: NSDictionary?
    var favoritesCount : Int?
    var userID: Int?
    
    var profileBackgroundURL : URL?
    
    var followersCount : Int?
    var followingCount : Int?
     var tweetsCount: Int?
    var friendsCount: Int?

    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? NSString
        screenname = dictionary["screen_name"] as? NSString
        let profileUrlString = dictionary["profile_image_url_https"]
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString as! String)
            
        }
        
        if let urlString = dictionary["profile_background_image_url_https"] as? String {
            profileBackgroundURL = URL(string: urlString)
        }
        
        
        if let idFromDict = dictionary["id"] as? Int {
            userID = idFromDict
        }
        
        tagline = dictionary["description"] as? String as NSString?
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        followersCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["following"] as? Int
        tweetsCount = dictionary["statuses_count"] as? Int
        friendsCount = dictionary["friends_count"] as? Int


    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
