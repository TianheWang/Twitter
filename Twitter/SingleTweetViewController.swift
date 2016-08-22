//
//  SingleTweetViewController.swift
//  Twitter
//
//  Created by tianhe_wang on 8/19/16.
//  Copyright © 2016 tianhe_wang. All rights reserved.
//

import UIKit

class SingleTweetViewController: UIViewController {


    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!

    var tweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.setImageWithURL((tweet?.user?.profileUrl)!)
        userName.text = tweet?.user?.name as? String
        let userHandleString = tweet?.user?.screenName as? String
        userHandle.text = "@\(userHandleString!)"
        tweetText.text = tweet?.text as? String
        favoriteCount.text = "\((tweet?.favoritesCount)!)"
        retweetCount.text = "\((tweet?.retweetCount)!)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
