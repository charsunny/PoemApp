//
//  MenuViewController.swift
//  PoemApp
//
//  Created by 诺崇 on 15/6/13.
//  Copyright (c) 2015年 charsunny. All rights reserved.
//

import Cocoa

let kListTabNotification = "kListSelectNotification"
let kHistoryTabSelectNotification = "kHistoryListSelectNotification"
let kSearchTabSelectNotification = "kSearchListSelectNotification"
let kUserTabSelectNotification = "kUserTabSelectNotification"

class MenuViewController: NSViewController,NSMatrixDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func onRecomand(sender: NSMatrix) {
        NSNotificationCenter.defaultCenter().postNotificationName(kListTabNotification, object: nil)
    }
    
    @IBAction func onHistory(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(kHistoryTabSelectNotification, object: nil)
    }
    
    
    @IBAction func onSearch(sender: AnyObject) {
         NSNotificationCenter.defaultCenter().postNotificationName(kSearchTabSelectNotification, object: nil)
    }
    
    @IBAction func onUser(sender: AnyObject) {
         NSNotificationCenter.defaultCenter().postNotificationName(kUserTabSelectNotification, object: nil)
    }
    
}
