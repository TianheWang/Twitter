//
//  Tweet.swift
//  Twitter
//
//  Created by tianhe_wang on 8/16/16.
//  Copyright © 2016 tianhe_wang. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: Int?
    var text: NSString?
    var timeString: String?
    var retweetCount: Int? = 0
    var favoritesCount: Int? = 0
    var user: User?
    var favorited: Bool?
    var retweeted: Bool?

    init(dictionary: NSDictionary) {
        super.init()
        id = dictionary["id"] as? Int
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            let timestamp = formatter.dateFromString(timestampString)
            timeString = processedTimeString(timestamp!)
        }
        let userData = dictionary["user"] as? NSDictionary
        user = User(dictionary: userData!)
        retweetCount = dictionary["retweet_count"] as? Int
        favorited = dictionary["favorited"] as? Bool
        retweeted = dictionary["retweeted"] as? Bool
    }

    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }

        return tweets
    }

    // modified from https://gist.github.com/minorbug/468790060810e0d29545
    private func processedTimeString(timestamp: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let unitFlags: NSCalendarUnit = [.Second, .Minute, .Hour, .Day, .WeekOfYear, .Month, .Year]
        let components = calendar.components(unitFlags, fromDate: timestamp, toDate: now, options: [])

        if components.year >= 1 || components.month > 1 || components.day > 1 {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .NoStyle
            return formatter.stringFromDate(timestamp)
        }

        if components.hour >= 1 {
            return "\(components.hour)h ago"
        }

        if components.minute >= 1 {
            return "\(components.minute)m ago"
        }

        if components.second >= 1 {
            return "\(components.second)s ago"
        }
        
        return "now"
    }
}
