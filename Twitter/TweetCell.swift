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
    @IBOutlet weak var likeButton: UIButton!

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
