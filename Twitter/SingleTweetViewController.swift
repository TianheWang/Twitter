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

    var tweet: Tweet! {
        didSet {
            self.loadViewIfNeeded()
            if tweet.retweetCount == nil && tweet.retweetCount == 0 {
                retweetCount.hidden = true
            } else {
                retweetCount.hidden = false
                retweetCount.text = "\(tweet.retweetCount!)"
            }

            if let tweetFavCount = tweet.favoritesCount {
                if tweetFavCount == 0 {
                    favoriteCount.hidden = true
                } else {
                    favoriteCount.hidden = false
                    favoriteCount.text = "\(tweet.favoritesCount!)"
                }
            } else {
                favoriteCount.hidden = true
            }

            if let favorited = tweet.favorited {
                if favorited {
                    favoriteButton.setImage(UIImage(named: "like-action-on"), forState: UIControlState.Normal)
                } else {
                    favoriteButton.setImage(UIImage(named: "like-action"), forState: UIControlState.Normal)
                }
            } else {
                favoriteButton.setImage(UIImage(named: "like-action"), forState: UIControlState.Normal)
            }

            if let retweeted = tweet.retweeted {
                if retweeted {
                    retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: UIControlState.Normal)
                } else {
                    retweetButton.setImage(UIImage(named: "retweet-action"), forState: UIControlState.Normal)
                }
            } else {
                retweetButton.setImage(UIImage(named: "retweet-action"), forState: UIControlState.Normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.setImageWithURL((tweet?.user?.profileUrl)!)
        userName.text = (tweet?.user?.name!)! as String
        let userHandleString = (tweet?.user?.screenName!)! as String
        userHandle.text = "@\(userHandleString)"
        tweetText.text = tweet?.text as? String
        favoriteCount.text = "\((tweet?.favoritesCount)!)"
        retweetCount.text = "\((tweet?.retweetCount)!)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweetButton(sender: AnyObject) {
        if let tweet = tweet {
            if !(tweet.retweeted!) {
                TwitterClient.sharedInstance.retweet(
                    (tweet.id)!,
                    success: {() -> () in
                        TwitterClient.sharedInstance.getTweet(
                            tweet.id!,
                            success: { (updatedTweet: Tweet) -> () in
                                self.tweet = updatedTweet
                            },
                            failure: { (error: NSError) -> () in
                                print(error.localizedDescription)
                            }
                        )
                    },
                    failure: { (error: NSError) -> () in
                        print(error.localizedDescription)
                    }
                )
            } else {
                TwitterClient.sharedInstance.unretweet(
                    (tweet.id)!,
                    success: {() -> () in
                        TwitterClient.sharedInstance.getTweet(
                            tweet.id!,
                            success: { (updatedTweet: Tweet) -> () in
                                self.tweet = updatedTweet
                            },
                            failure: { (error: NSError) -> () in
                                print(error.localizedDescription)
                            }
                        )
                    },
                    failure: { (error: NSError) -> () in
                        print(error.localizedDescription)
                    }
                )
            }
        }
    }

    @IBAction func onFavoriteButton(sender: AnyObject) {
        if let tweet = tweet {
            if !(tweet.favorited!) {
                TwitterClient.sharedInstance.favorite(
                    (tweet.id)!,
                    success: {() -> () in
                        TwitterClient.sharedInstance.getTweet(
                            tweet.id!,
                            success: { (updatedTweet: Tweet) -> () in
                                self.tweet = updatedTweet
                            },
                            failure: { (error: NSError) -> () in
                                print(error.localizedDescription)
                            }
                        )
                    },
                    failure: { (error: NSError) -> () in
                        print(error.localizedDescription)
                    }
                )
            } else {
                TwitterClient.sharedInstance.unfavorite(
                    (tweet.id)!,
                    success: {() -> () in
                        TwitterClient.sharedInstance.getTweet(
                            tweet.id!,
                            success: { (updatedTweet: Tweet) -> () in
                                self.tweet = updatedTweet
                            },
                            failure: { (error: NSError) -> () in
                                print(error.localizedDescription)
                            }
                        )
                    },
                    failure: { (error: NSError) -> () in
                        print(error.localizedDescription)
                    }
                )
            }
        }
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "singleTweetReply" {
            let prefix = "@\((tweet.user?.screenName)!) "
            let navigationController = segue.destinationViewController as! UINavigationController
            let newTweetViewController = navigationController.topViewController as! NewTweetViewController
            newTweetViewController.prefix = prefix
        }
    }

}
