//
//  TweetsViewController.swift
//  Twitter
//
//  Created by tianhe_wang on 8/17/16.
//  Copyright © 2016 tianhe_wang. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
//        ???  look into sharedInstance, sigleton
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })


        // pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogouButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }

    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "singleTweetSegue":
            let cell = sender as! TweetCell
            let singleTweetViewController = segue.destinationViewController as! SingleTweetViewController
            singleTweetViewController.tweet = cell.tweet
        case "newTweetSegue":
            break
        case "replySegue":
            let replyButton = sender as! UIButton
            let cell = replyButton.superview?.superview as! TweetCell
            let prefix = "@\((cell.tweet!.user?.screenName)!) "
            let navigationController = segue.destinationViewController as! UINavigationController
            let newTweetViewController = navigationController.topViewController as! NewTweetViewController
            newTweetViewController.prefix = prefix
            break
        case "profileSegue":
            let cell = sender as! TweetCell
            let user = cell.tweet.user
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.user = user
        default:
            return
        }

    }

    
    @IBAction func onRetweetButton(sender: AnyObject) {
        let retweetButton = sender as! UIButton
        let cell = retweetButton.superview?.superview as! TweetCell
        let tweet = cell.tweet
        if let tweet = tweet {
            if !(tweet.retweeted!) {
                TwitterClient.sharedInstance.retweet(
                    (tweet.id)!,
                    success: {() -> () in
                        TwitterClient.sharedInstance.getTweet(
                            tweet.id!,
                            success: { (updatedTweet: Tweet) -> () in
                                let indexPath = self.tableView.indexPathForCell(cell)
                                self.tweets[indexPath!.row] = updatedTweet
                                self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
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
                                let indexPath = self.tableView.indexPathForCell(cell)
                                self.tweets[indexPath!.row] = updatedTweet
                                self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
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
        let favButton = sender as! UIButton
        let cell = favButton.superview?.superview as! TweetCell
        let tweet = cell.tweet
        if let tweet = tweet {
            if !(tweet.favorited!) {
                TwitterClient.sharedInstance.favorite(
                    (tweet.id)!,
                    success: {() -> () in
                        TwitterClient.sharedInstance.getTweet(
                            tweet.id!,
                            success: { (updatedTweet: Tweet) -> () in
                                let indexPath = self.tableView.indexPathForCell(cell)
                                self.tweets[indexPath!.row] = updatedTweet
                                self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
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
                                let indexPath = self.tableView.indexPathForCell(cell)
                                self.tweets[indexPath!.row] = updatedTweet
                                self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
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
    
}

extension TweetsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension TweetsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.navigationController = navigationController
        return cell
    }
}