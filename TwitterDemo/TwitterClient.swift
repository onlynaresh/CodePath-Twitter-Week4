//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Yerneni, Naresh on 4/14/17.
//  Copyright © 2017 Yerneni, Naresh. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey:"0YmhMkUxtoHPpHXmodnktWbAv" , consumerSecret:"quGtQcbaDSrIO6ysKoEN4jM4q3rrqHywZlZpRXDRRmJEo1vrQd" )
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error?) -> Void in
            failure(error!)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()){
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetWithArray(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(
            withPath: "oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "twitterdemonaresh://oauth") as URL!,
            scope: nil,
            success: { (requestToken: BDBOAuth1Credential?) -> Void in
                if let token = requestToken?.token {
                    let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
                    
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                    print("\(token)")
                }
        }) { (error: Error?) -> Void in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        }
    }
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func tweet(message: String, reply_id:String?, success:@escaping (Any?) -> (), failure:@escaping (Error) -> ()) {
        let endpoint = "1.1/statuses/update.json?"
        var params = "status=\(message)"
        if reply_id != nil {
            params += "&in_reply_to_status_id=\(reply_id!)"
        }
        params = params.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        post(endpoint+params, parameters: nil, progress: nil, success: {
            (task: URLSessionDataTask,response: Any?) -> Void in
            success(response)
        }, failure: {(task: URLSessionDataTask?, error: Error?) -> Void in
            failure(error!)
        })
    }
    
    
    func post(favoriteTweetID : Int,  success : @escaping (Tweet) -> (), error : @escaping (Error) -> ()) {
        
        
        let params = ["id" : favoriteTweetID]
        TwitterClient.sharedInstance?.post("1.1/favorites/create.json",
                                        parameters: params,
                                        progress: nil,
                                        success: { (task, response) in
                                            if let dictionary = response as? NSDictionary {
                                                let tweet = Tweet(dictionary: dictionary);
                                                success(tweet)
                                            } else {
                                                error(NSError(domain: "unable to post tweet", code: 0, userInfo: nil))
                                            }
        }) { (task, receivedError) in
            error(receivedError)
        }
        
        
    }
    
    func post(unfavoriteTweetID : Int,  success : @escaping (Tweet) -> (), error : @escaping (Error) -> ()) {
        
        
        let params = ["id" : unfavoriteTweetID]
        TwitterClient.sharedInstance?.post("1.1/favorites/destroy.json",
                                        parameters: params,
                                        progress: nil,
                                        success: { (task, response) in
                                        if let dictionary = response as? NSDictionary {
                                                let tweet = Tweet(dictionary: dictionary);
                                                success(tweet)
                                            } else {
                                                error(NSError(domain: "unable to post tweet", code: 0, userInfo: nil))
                                            }
        }) { (task, receivedError) in
            error(receivedError)
        }
        
    }
    

    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                print("user: \(User.currentUser)")
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            
        }) { (error: Error?) in
            print("error: \(error!.localizedDescription)")
            self.loginFailure?(error!)
        }
    }
}
