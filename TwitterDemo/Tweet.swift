//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Yerneni, Naresh on 4/14/17.
//  Copyright © 2017 Yerneni, Naresh. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: NSString?
    var timestampDt: NSDate?
    var timestamp:String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var tweetID:Int?
    
     var favorited : Bool?
    
    init(dictionary: NSDictionary) {
        let userDictionary = dictionary["user"] as? NSDictionary
        if let userDictionary = userDictionary {
            user = User(dictionary: userDictionary)
        }
        text = (dictionary["text"] as? NSString?)!
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestampDt = formatter.date(from: timestampString) as NSDate?
            timestamp = Tweet.shortTimeAgoSinceDate(date: timestampDt!)

        }
        
        favorited = (dictionary["favorited"] as? Bool?) ?? false
        print("the favorited values in tweet:" + String(describing: favorited))
        
        if let id = dictionary["id"] as? Int {
            tweetID = id
        }
        

        
    }
    
    
    func updateWith(tweet : Tweet) {
        retweetCount = tweet.retweetCount
        favorited = tweet.favorited
        favoritesCount = tweet.favoritesCount
    }
    
    class func shortTimeAgoSinceDate(date: NSDate) -> String {
        
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        
        let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.weekOfYear, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second], from: earliest, to: latest as Date)
        
        
        if (components.year! >= 1) {
            return "\(components.year!)y"
        } else if (components.month! >= 1) {
            return "\(components.month!)m"
        } else if (components.weekOfYear! >= 1) {
            return "\(components.weekOfYear!)w"
        } else if (components.day! >= 1) {
            return "\(components.day!)d"
        } else if (components.hour! >= 1) {
            return "\(components.hour!)h"
        } else if (components.minute! >= 1) {
            return "\(components.minute!)m"
        } else if (components.second! >= 3) {
            return "\(components.second!)s"
        } else {
            return "now"
        }
    }

    
    class func tweetWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictonary in dictionaries {
            let tweet = Tweet(dictionary: dictonary)
            tweets.append(tweet)
        }
        return tweets
    }
}
