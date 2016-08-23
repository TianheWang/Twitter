//
//  TwitterClient.swift
//  Twitter
//
//  Created by tianhe_wang on 8/16/16.
//  Copyright © 2016 tianhe_wang. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let userDidLogoutNotification = "UserDidLogout"

    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "VO2FSdgwXVLw4uydZFdf0PNu6", consumerSecret: "wvhHYRvWEDLfy9IaZ2KzYJGtdGcGI3tYBmfgecnnFT7XODguDt")

    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?

    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure

        deauthorize()

        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "mytwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("I got a token!")
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            }, failure: {(error: NSError!) -> Void  in
                print("at request token")
                self.loginFailure?(error)
        })
    }

    func logout() {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(TwitterClient.userDidLogoutNotification, object: nil)
    }

    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)

        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: {
            (accessToken: BDBOAuth1Credential!) -> Void in

            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) -> () in
                print("at fetch access token")
                self.loginFailure?(error)
            })


        }, failure: {
                (error: NSError!) -> Void in
                print("at open url")
                self.loginFailure?(error)
        })
    }

    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweetsDictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(tweetsDictionaries)
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("at fetch timeline")
                failure(error)
        })
    }

    func mentionTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweetsDictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(tweetsDictionaries)
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("at fetch mentions")
                failure(error)
        })
    }

    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("at create account")
                failure(error)
        })
    }

    func tweet(tweetText: String, success: () -> (), failure: (NSError) -> ()) {
        POST("1.1/statuses/update.json", parameters: ["status": tweetText], progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("at new tweet")
                failure(error)
        })
    }

    func favorite(tweetId: Int, success: () -> (), failure: (NSError) -> ()) {
        POST("1.1/favorites/create.json", parameters: ["id": tweetId], progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("at fav tweet")
                failure(error)
        })
    }

    func unfavorite(tweetId: Int, success: () -> (), failure: (NSError) -> ()) {
        POST("1.1/favorites/destroy.json", parameters: ["id": tweetId], progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("at unfav tweet")
                failure(error)
        })
    }

    func retweet(tweetId: Int, success: () -> (), failure: (NSError) -> ()) {
        POST("1.1/statuses/retweet/\(tweetId).json", parameters: ["id": tweetId], progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("at retweet")
                failure(error)
        })
    }

    func unretweet(tweetId: Int, success: () -> (), failure: (NSError) -> ()) {
        POST("1.1/statuses/unretweet/\(tweetId).json", parameters: ["id": tweetId], progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("at unretweet")
                failure(error)
        })
    }

    func getTweet(tweetId: Int, success: (Tweet) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/show.json", parameters: ["id": tweetId], progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweetDictionary)
            success(tweet)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("at get tweet")
                failure(error)
        })
    }
}
