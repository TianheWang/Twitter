//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by tianhe_wang on 8/21/16.
//  Copyright © 2016 tianhe_wang. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var contentViewLeftConstraint: NSLayoutConstraint!

    var originalContentViewLeftMargin: CGFloat!
    let leftEdgeMax: CGFloat = 120
    var menuViewController: MenuViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }

    var contentViewController: UIViewController! {
        didSet(oldcontentViewController) {
            view.layoutIfNeeded()

            if oldcontentViewController != nil {
                oldcontentViewController.willMoveToParentViewController(nil)
                oldcontentViewController.view.removeFromSuperview()
                oldcontentViewController.didMoveToParentViewController(nil)
            }

            contentViewController.willMoveToParentViewController(self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMoveToParentViewController(self)
            UIView.animateWithDuration(0.3, animations: {
                self.contentViewLeftConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
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
    
    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        switch sender.state {
        case .Began:
            originalContentViewLeftMargin = contentViewLeftConstraint.constant
        case .Changed:
            if translation.x >= leftEdgeMax || contentViewLeftConstraint.constant >= leftEdgeMax {
                contentViewLeftConstraint.constant = leftEdgeMax
            } else if translation.x <= 0 && contentViewLeftConstraint.constant <= 0 {
                contentViewLeftConstraint.constant = 0
            } else {
                contentViewLeftConstraint.constant = originalContentViewLeftMargin + translation.x
            }
        case .Ended:
            UIView.animateWithDuration(
                0.3, animations: {
                    if velocity.x > 0 {
                        self.contentViewLeftConstraint.constant = self.leftEdgeMax
                    } else {
                        self.contentViewLeftConstraint.constant = 0
                    }
                    self.view.layoutIfNeeded()
            })

        default:
            break
        }
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
