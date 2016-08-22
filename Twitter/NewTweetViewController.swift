//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by tianhe_wang on 8/21/16.
//  Copyright © 2016 tianhe_wang. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {


    @IBOutlet weak var tweetText: UITextField!

    @IBOutlet weak var charLeft: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onTweetButton(sender: AnyObject) {
        let newTweetText = tweetText.text
        if let newTweetText = newTweetText {
            TwitterClient.sharedInstance.tweet(newTweetText, success: { () -> () in
                print(newTweetText)
                self.dismissViewControllerAnimated(true, completion: nil)
                }, failure: { (error: NSError) -> () in
                    print(error.localizedDescription)
            })

        }
    }

    @IBAction func onEditing(sender: AnyObject) {
        var charLeftCount = 0
        if let tweetText = tweetText.text {
            charLeftCount = 140 - tweetText.characters.count
        }
        charLeft.text = "\(charLeftCount) Characters Left"
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
