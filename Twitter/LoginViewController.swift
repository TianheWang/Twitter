//
//  LoginViewController.swift
//  Twitter
//
//  Created by tianhe_wang on 8/16/16.
//  Copyright © 2016 tianhe_wang. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // ???? read about the success and failure handler
    @IBAction func onLoginButton(sender: AnyObject) {

        TwitterClient.sharedInstance.login({ () -> () in
            print("I've logged in")
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            delegate.configViews()
        }, failure: {
                (error: NSError) -> () in
                print(error.localizedDescription)
        })

    }


    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
