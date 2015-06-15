//
//  AuthorPopoverViewController.swift
//  PoemApp
//
//  Created by sunsing on 6/14/15.
//  Copyright (c) 2015 charsunny. All rights reserved.
//

import Cocoa

class AuthorPopoverViewController: NSViewController {

    @IBOutlet weak var authorName: NSTextField!
    
    @IBOutlet weak var authorImageView: NSImageView!
    
    @IBOutlet var authorDesc: NSTextView!
    
    var author:Author!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorName.stringValue = author.name
        if let image = NSImage(contentsOfURL: NSURL(string: "http://so.gushiwen.org/authorImg/\(author.pinyin).jpg")!) {
            authorImageView.image = image
        }
        authorDesc.string = author.desc
        authorImageView.wantsLayer = true
        authorImageView.layer?.cornerRadius = 24
        authorImageView.layer?.borderWidth = 0.5
        authorImageView.layer?.borderColor = NSColor.gridColor().CGColor
    }
    
}
