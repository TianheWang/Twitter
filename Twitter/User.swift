//
//  User.swift
//  Twitter
//
//  Created by tianhe_wang on 8/16/16.
//  Copyright © 2016 tianhe_wang. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: NSString?
    var screenName: NSString?
    var profileUrl: NSURL?
    var tagLine: NSString?
    var userData: NSDictionary?

    init(dictionary: NSDictionary) {
        userData = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        print(profileUrlString)
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        tagLine = dictionary["description"] as? String
    }

    static var _currrentUser: User?

    class var currentUser: User? {
        get {
            // ???? what's the difference between if someVar == nil and if let someVar = someVar?
            if _currrentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let data = defaults.objectForKey("currentUserData") as? NSData

                if let data = data {
                    // ???? where's catch
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary
                    _currrentUser = User(dictionary: dictionary!)
                }
            }
            return _currrentUser
        }

        set(user) {
            _currrentUser = user

            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.userData!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
