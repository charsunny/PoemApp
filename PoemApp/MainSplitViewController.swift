//
//  MainSplitViewController.swift
//  PoemApp
//
//  Created by 诺崇 on 15/6/9.
//  Copyright © 2015年 charsunny. All rights reserved.
//

import Cocoa


let kShowPoemNotification  = "showPoemNotificaion"
let kShowEmptyNotification  = "showEmptyContentNotification"

class MainSplitViewController: NSSplitViewController {
    
    var menuViewController:MenuViewController!
    var contentRootViewController:ContentRootViewController!
    var listRootViewController:ListRootViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showPoem:", name: kShowPoemNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showEmptyView:", name: kShowEmptyNotification, object: nil)
        for splitViewItem in splitViewItems {
            if let splitViewItem = splitViewItem as? NSSplitViewItem {
                let vc = splitViewItem.viewController
                if vc is MenuViewController {
                    menuViewController = vc as! MenuViewController
                } else if vc is ListRootViewController {
                    listRootViewController = vc as! ListRootViewController
                } else if vc is ContentRootViewController {
                    contentRootViewController = vc as! ContentRootViewController
                }
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: notification handler
    func showPoem(notif:NSNotification) {
        if let poem = notif.userInfo!["poem"] as? Poem {
            contentRootViewController.showPoem(poem)
        }
    }
    
    func showEmptyView(notif:NSNotification) {
        contentRootViewController.showEmptyView()
    }

}
