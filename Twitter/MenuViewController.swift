//
//  MenuViewController.swift
//  Twitter
//
//  Created by tianhe_wang on 8/21/16.
//  Copyright © 2016 tianhe_wang. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var hamburgerViewController: HamburgerViewController! {
        didSet {

        }
    }

    private var tweetsViewNavigationController: UINavigationController!
    private var profileViewNavigationController: UINavigationController!

    var viewControllers: [UINavigationController] = []
    let titles: [String] = ["Home", "Profile"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        tweetsViewNavigationController = storyBoard.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
        profileViewNavigationController = storyBoard.instantiateViewControllerWithIdentifier("ProfileNavigationController") as! UINavigationController
        let profileViewController = profileViewNavigationController.topViewController as! ProfileViewController
        profileViewController.user = User.currentUser
        viewControllers.append(tweetsViewNavigationController)
        viewControllers.append(profileViewNavigationController)

        hamburgerViewController.contentViewController = tweetsViewNavigationController

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

extension MenuViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) as! MenuCell
        cell.viewLabel.text = titles[indexPath.row]
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]

    }
}