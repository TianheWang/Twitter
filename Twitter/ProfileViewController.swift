//
//  ProfileViewController.swift
//  Twitter
//
//  Created by tianhe_wang on 8/22/16.
//  Copyright © 2016 tianhe_wang. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileHeaderView: UIView!

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!

    @IBOutlet weak var favoriteLabel: UILabel!

    @IBOutlet weak var followersLabel: UILabel!

    var user: User! {
        didSet {
            view.layoutIfNeeded()
            if let backgroundImageUrl = user.backgroundImageUrl {
                backgroundImage.setImageWithURL(backgroundImageUrl)
            }
            if let profileImageUrl = user.profileUrl {
                profileImage.setImageWithURL(profileImageUrl)
            }
            userName.text = user.name!
            userHandle.text = "@\(user.screenName!)"
            followersLabel.text = "\(user.followerCount!)"
            favoriteLabel.text = "\(user.favoriteCount!)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
