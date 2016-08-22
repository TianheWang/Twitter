//
//  TweetCell.swift
//  Twitter
//
//  Created by tianhe_wang on 8/17/16.
//  Copyright © 2016 tianhe_wang. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    // @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!



    var tweet: Tweet! {
        didSet {
            if let user = tweet.user {
                if let image_url = user.profileUrl {
                    profileImage.setImageWithURL(image_url)
                }
                userName.text = user.name as? String
                let handle = user.screenName as? String
                userHandle.text = "@\(handle!)"
            }

//            let now: NSDate = NSDate()

            tweetText.text = tweet.text as? String
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

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = 5
        profileImage.clipsToBounds = true
//        tweetText.preferredMaxLayoutWidth = tweetText.frame.size.width
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
