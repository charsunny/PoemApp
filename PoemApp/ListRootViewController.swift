//
//  ViewController.swift
//  PoemApp
//
//  Created by 诺崇 on 15/6/9.
//  Copyright © 2015年 charsunny. All rights reserved.
//

import Cocoa

class ListRootViewController: NSViewController {

    var currentViewController:NSViewController!
    var listViewController:ListViewController!
    var historyListViewController:HistoryListViewController!
    var searchListViewController:SearchListViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onListTab:", name: kListTabNotification, object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "onHistoryTab:", name: kHistoryTabSelectNotification, object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "onSearchTab:", name: kSearchTabSelectNotification, object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "onUserTab:", name: kUserTabSelectNotification, object: nil)
        for vc in self.childViewControllers {
            if let vc = vc as? NSViewController {
                if vc is ListViewController {
                    listViewController = vc as! ListViewController
                } else if vc is HistoryListViewController {
                    historyListViewController = vc as! HistoryListViewController
                } else if vc is SearchListViewController {
                    searchListViewController = vc as! SearchListViewController
                }
            }
        }
        currentViewController = listViewController
        historyListViewController.view.removeFromSuperview()
        searchListViewController.view.removeFromSuperview()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func onListTab(notif:NSNotification) {
        if currentViewController != listViewController {
            NSNotificationCenter.defaultCenter().postNotificationName(kShowEmptyNotification, object: nil)
            self.listViewController.tableView.deselectAll(nil)
            self.transitionFromViewController(currentViewController, toViewController: listViewController, options: NSViewControllerTransitionOptions.Crossfade, completionHandler: { () -> Void in
                self.currentViewController = self.listViewController
            })
        }
        
    }
    
    func onHistoryTab(notif:NSNotification) {
        if currentViewController != historyListViewController {
            NSNotificationCenter.defaultCenter().postNotificationName(kShowEmptyNotification, object: nil)
            self.historyListViewController.tableView.deselectAll(nil)
            self.transitionFromViewController(currentViewController, toViewController: historyListViewController, options: NSViewControllerTransitionOptions.Crossfade, completionHandler: { () -> Void in
                self.currentViewController = self.historyListViewController
            })
        }
    }
    
    func onSearchTab(notif:NSNotification) {
        if currentViewController != searchListViewController {
            NSNotificationCenter.defaultCenter().postNotificationName(kShowEmptyNotification, object: nil)
            self.transitionFromViewController(currentViewController, toViewController: searchListViewController, options: NSViewControllerTransitionOptions.Crossfade, completionHandler: { () -> Void in
                self.currentViewController = self.searchListViewController
            })
        }
    }
    
    func onUserTab(notif:NSNotification) {
        
    }
}

