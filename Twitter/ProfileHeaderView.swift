//
//  ProfileHeaderViewController.swift
//  Twitter
//
//  Created by tianhe_wang on 8/22/16.
//  Copyright © 2016 tianhe_wang. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {



    @IBOutlet weak var backgroundImage: UIImageView!

    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var userName: UILabel!

    @IBOutlet weak var userHandle: UILabel!

    var user: User! {
        didSet {
            if let backgroundImageUrl = user.backgroundImageUrl {
                backgroundImage.setImageWithURL(backgroundImageUrl)
                userName.textColor = UIColor.whiteColor()
                userHandle.textColor = UIColor.whiteColor()
            }
            if let profileImageUrl = user.profileUrl {
                profileImage.setImageWithURL(profileImageUrl)
            }
            userName.text = user.name!
            userHandle.text = "@\(user.screenName!)"
        }
    }

//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        let nib = UINib(nibName: "UserProfileHeaderView", bundle: nil)
//        nib.instantiateWithOwner(self, options: nil)
//        self.view.frame = bounds
//        addSubview(contentView)
//    }
}
