//
//  LoginViewControlle.swift
//  TwitterDemo
//
//  Created by Yerneni, Naresh on 4/13/17.
//  Copyright © 2017 Yerneni, Naresh. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewControlle: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    @IBAction func onLogin(_ sender: Any) {
        
        TwitterClient.sharedInstance?.login(success: {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


 
 }
