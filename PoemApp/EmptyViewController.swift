//
//  EmptyViewController.swift
//  PoemApp
//
//  Created by 诺崇 on 15/6/13.
//  Copyright (c) 2015年 charsunny. All rights reserved.
//

import Cocoa

class EmptyViewController: NSViewController {

    @IBOutlet weak var bgImageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        bgImageView.wantsLayer = true
        bgImageView.layer?.cornerRadius = 100
        bgImageView.layer?.masksToBounds = true
        bgImageView.image = NSImage(named: "theme\(index)")
    }
    
    func showEmpty() {
        var index = arc4random()%7+1
        bgImageView.image = NSImage(named: "theme\(index)")
    }
    
}
