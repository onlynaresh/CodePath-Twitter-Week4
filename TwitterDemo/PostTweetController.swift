//
//  PostTweetController.swift
//  TwitterDemo
//
//  Created by Yerneni, Naresh on 4/15/17.
//  Copyright © 2017 Yerneni, Naresh. All rights reserved.
//

import UIKit

class PostTweetController: UIViewController,UITextViewDelegate {

    

    @IBOutlet weak var profImage: UIImageView!
    
    @IBOutlet weak var characterLimitLabel: UILabel!
    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var handleLabel: UILabel!
    
    var lettersRemaining: Int = 140
    let Max = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetText.delegate = self
        setCurrentUserProfile()
        
       
    }
    
    @IBAction func postATweet(_ sender: Any) {
        if (lettersRemaining > 0) {
            let text = tweetText.text
            TwitterClient.sharedInstance?.tweet(message: text!, reply_id: nil, success: {(response: Any) -> () in
                self.dismiss(animated: true, completion: {});
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "postTweet"), object: response)
            }, failure: {(error:Error) -> () in
                print(error.localizedDescription)
            })
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = tweetText.text.characters.count
        lettersRemaining = Max - count
        characterLimitLabel.text = String(lettersRemaining)
        
        if (lettersRemaining > 0) {
            characterLimitLabel.textColor = UIColor.gray
        } else {
            characterLimitLabel.textColor = UIColor.red
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil);
    }

    
    func setCurrentUserProfile(){
        let user = User.currentUser!
        nameLabel.text = user.name as String?
        if user.screenname != nil {
            handleLabel.text = "@\(String(describing: user.screenname!))"
        }
      
        profImage.setImageWith((user.profileUrl)! as URL)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
